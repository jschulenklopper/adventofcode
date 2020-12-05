require 'pp'

PLAYER = 0
BOSS = 1 

# Create structure for players, and create those two.
Player = Struct.new(:name, :hp, :armor, :mana, :damage, keyword_init: true)
player = Player.new(name: "Player", hp: 10, armor: 0, mana: 250)
boss = Player.new(name: "Boss", hp: 13, armor: 0, damage: 8, mana: 0)
$players = [player, boss]

# Create structure for spells, and create the series of spells.
$spells = []
Spell = Struct.new(:name, :cost, :damage, :healing, :timer, :armor, :mana, keyword_init: true)
$spells << Spell.new(name: "Magic Missile", cost: 53, damage: 4)
$spells << Spell.new(name: "Drain", cost: 73, damage: 2, healing: 2)
$spells << Spell.new(name: "Shield", cost: 113, timer: 6, armor: 7)
$spells << Spell.new(name: "Poison", cost: 173, timer: 6, damage: 3)
$spells << Spell.new(name: "Recharge", cost: 229, timer: 5, mana: 101)

# Attack (boss' move) is pseudo spell.
$attack = Spell.new(name: "Attack", cost: 0, damage: 8)

class Spell
  def pp
    str = ""
    self.each_pair { |a,v| str += "%s: %s " % [a, v] if v != nil }
    puts str
  end
end

# Set initial state
Game = Struct.new(:players, :active_spells, :next_to_move, :moves, keyword_init: true)
$game = Game.new(players: $players, active_spells: [], next_to_move: PLAYER, moves: [])

class Game
  def pp
    puts "\n-- %s turn --" % [self.players[self.next_to_move].name]

    str = "- #{self.players[PLAYER].name} has "
    self.players[PLAYER].each_pair { |a,v| str += "%s %s " % [v, a] if v != nil and a != :name }
    puts str

    str = "- #{self.players[BOSS].name} has "
    self.players[BOSS].each_pair { |a,v| str += "%s %s " % [v, a] if v != nil and a != :name }
    puts str

    puts "- spells active:"
    self.active_spells.each do |spell|
      puts "- %s is active, timer is now %s" % [spell.name, spell.timer]
    end

    puts "- moves done: %s" % [self.moves.length]
    self.moves.each do |move|
      move.pp
    end
    puts
  end
end

# Lambda function to generate next moves.
$f_next_moves = lambda do |game, spells|
  moves = []
  if game.next_to_move == BOSS
    moves << $attack
  else
    spells.each do |spell|
      moves << spell if not game.active_spells.include?(spell)
    end
  end
  moves
end


# Lambda function to signal when game is over.
$f_game_over = lambda do |game, spells|
  cheapest_spell = spells.map(&:cost).min
  min_hp = game.players.map(&:hp).min
  player_mana = game.players[PLAYER].mana

  # Game is over when one player's hit points are zero or less or if no spell can be cast by player.
  puts "game over? %s" % [min_hp <= 0 || player_mana < cheapest_spell]
  return min_hp <= 0 || player_mana < cheapest_spell
end 


# Lambda function to compute scope of a game position.
$f_score = lambda do |game|
  puts "** Scoring game **"
  game.pp
  game.players[PLAYER].mana
end


# Return new game situation after applying move.
def do_move(move, game)
  puts "+ move"
  move.pp

  # Deduct price of move (spell) from mana.
  game.players[game.next_to_move].mana -= move.cost

  # Determine other player.
  other_player = (game.next_to_move == PLAYER) ? BOSS : PLAYER

  # Poison has damage too... but it's not applied immediately. So exclude that.
  if move.damage && move.name != "Poison"
    game.players[other_player].hp -= [move.damage - game.players[other_player].armor, 1].max if move.damage
  end

  # Apply Drain; it has a healing effect too.
  game.players[PLAYER].hp += move.healing if move.healing

  game
end


# Return new game situation after applying spell.
# Luckily, spells only come from PLAYER, so it's clear what's affected.
def do_spell(spell, game)
  return game if spell.timer < 1  # Just to be sure...

  # Magic Missile and Drain have immediate effect, not a timed one.

  # Shield sets armor.
  game.players[PLAYER].armor = spell.armor

  # Poison deals damage.
  game.players[BOSS] -= spell.damage
    
  # Recharge adds mana.
  game.players[PLAYER] += spell.mana

  game
end


def play(game, spells)
  # Initial position is 'game situation' to start with.
  queue = [game]

  # Solutions is a list of (winning) scores.
  solutions = []
  
  while current_game = queue.shift do
    puts "=== Begin of next loop"
    puts queue.length

    puts "Current game:"
    current_game.pp

    # Test if game is over.
    if $f_game_over.call(current_game, spells)
      # Add score to solutions.
      solutions << $f_score.call(current_game)
      next
    end

    # Reset armor to 0 for player. (It might be increased because of spell.)
    game.players[PLAYER].armor = 0

    # Apply any spells that are active.
    current_game.active_spells.each do |spell| 
      do_spell(spell, current_game)
    end

    puts "After applying spells"
    current_game.pp

    # Decrease timer of all active spells.
    current_game.active_spells.each { |spell| spell.timer -= 1 }

    puts "After decreasing timers of spells"
    current_game.pp

    # Delete all the spells that aren't active anymore.
    current_game.active_spells.reject! { |spell| spell.timer < 1 }

    puts "After deleting inactive spells"
    current_game.pp

    # Generate list of next possible moves.
    next_moves = $f_next_moves.call(current_game, spells)

    puts "List of possible next moves"
    next_moves.each { |move| move.pp }  # DEBUG
    puts 

    # If no next moves (possible), then this is a lost game.
    if next_moves.empty?
      puts "No next moves from current game, so it's the end of this game."
      solutions << $f_score.call(current_game)
      next
    end

    # Apply all next moves to current game as potential new game situations.
    puts "Consider all possible next moves to create new games."
    next_games = next_moves.map.with_index do |move, i|
      puts "++ Begin of loop to create new game - %i" % i
      current_game.pp

      # Compute game after doing the move.
      new_game = do_move(move, current_game)

      puts "++ After applying move"
      new_game.pp

      # Add move to game.moves.
      new_game.moves.push(move)

      puts "++ After adding move to game.moves"
      new_game.pp

      # Add spell to game.active_spells.
      new_game.active_spells.push(move) if move.timer

      puts "++ After adding spell to game.active_spells"
      new_game.pp

      # Make the other player the next one to move.
      new_game.next_to_move = new_game.next_to_move == PLAYER ? BOSS : PLAYER

      puts "++ After changing player next to move"
      new_game.pp

      # Add this potential game to list of next games.
      puts "++ Returning new game"
      new_game
    end
    
    puts next_games.length

    # Add all possible next games to (end of) queue.
    # queue.concat(next_games)
    # DEBUG Add next games to beginning (!) of queue.
    # So we're going through this DFS, not BFS.
    puts "###"
    p queue
    p queue.length
    p next_games
    p next_games.length
    queue = queue + next_games
    p queue
    p queue.length
  end

  # Return all scores (solutions) of all games.
  solutions
end

puts play($game, $spells)
