START_AP = 3
START_HP = 200

require './unit.rb'
require './square.rb'
require './maze.rb'

input = gets(nil)
maze = Maze.new(input)

# Parse input and build map and armies.
y = 0
while line = gets
  break if line.strip.empty?

  x = 0
  line.strip.chars.each do |c|
    case c
    when " "
      break   # Break parsing line after space.
    when "#"  # For now, don't store walls.
    when "G"
      maze.squares << square = Square.new(x,y)
      maze.units << Unit.new(:goblin, square, 3, 200, true)
    when "E"
      maze.squares << square = Square.new(x,y)
      maze.units << Unit.new(:elf, square, 3, 200, true)
    when "."
      maze.squares << Square.new(x,y)
    end
    x += 1
  end
  y += 1
end

round = 1
sum_hp = 0

# Take turns until no opponents are alive.
while true
  puts "\n===\nround: %i" % round
  puts maze.to_s

  # Get (sorted) list of all units alive.
  units = maze.units_alive
  # puts units.map { |u| u.to_s }

  # Each unit still alive takes a turn.
  units.each do |unit|
    puts "---\nunit:"
    puts unit.to_s

    # a. Identify targets: opponents alive.
    opponents = maze.opponents_alive(unit)

    puts "opponents:"
    puts opponents.map { |o| o.to_s }

    #   1. If there aren't opponents: this unit's turn ends.
    break if opponents.length == 0

    # b. Find open squares in range of opponents.
    puts "squares in range:"
    squares_in_range = maze.squares_in_range(opponents)
    puts squares_in_range.map { |s| s.to_s }

    #    ... or opponents already in range.
    puts "opponents already in range:"
    opponents_in_range = maze.opponents_in_range(unit)
    puts opponents_in_range.map { |o| o.to_s }

    #    1. There might not be open squares or opponents in range:
    #       end this turn.
    if opponents_in_range.empty? && squares_in_range.empty?
      puts "for this unit, nothing to do"
      next
    end

    # c. If there's no opponent in range now: move.
    #    1. Find closest squares in range. Pick first.
    #    2. Find shortest routes. Pick first.
    #    3. Move.
    # d. If there's an opponent in range: attack.
    #    1. Find opponents in range. Pick weakest, or first.
    #    2. Attack.
    #    3. If target's HP 0 or lower, mark as dead.
  end

  round += 1
  break if round > 1  # Replace with exit condition.
end

# puts (round-1) * sum_hp