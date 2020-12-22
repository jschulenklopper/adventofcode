$decks = ARGF.readlines.join(",").          # Read the decks of the players.
             split(/Player \d:/).          # Split decks between players.
             map { |s| s.split(",").map(&:to_i) }.  # Make arrays of integers.
             select { |a| not a.empty? }.  # Remove empty deck (first one).
             map { |a| a.delete(0); a }    # Remove all zeros from decks.

puts "part 1"

decks = $decks.map { |d| d.dup }

def first_game(decks)
  until decks[0].length == 0 || decks[1].length == 0
    zero, one = decks[0].shift, decks[1].shift
    (zero > one) ? decks[0] << zero << one : decks[1] << one << zero
  end
  decks
end

def score(deck)
  deck.reverse.map.with_index { |card, i| (i+1) * card }.sum
end

# Get winning deck of first game.
winning = first_game(decks).find { |d| d.length > 0 }
# Compute score of winning deck.
puts score(winning)

puts "part 2"

decks = $decks.map { |d| d.dup }

def sub_game(decks, game)
  outcome = second_round(decks, game)
  (outcome[0].length > 0) ? 0 : 1  
end

def second_round(decks, game)
  memory = []
  winner = nil

  # Until both players have cards...
  until decks[0].length == 0 || decks[1].length == 0
    # End game when we've seen these decks before.
    if memory.include?(decks.to_s)
      return decks
    else
      memory << decks.to_s
    end

    # Players draw top cards.
    zero, one = decks[0].shift, decks[1].shift

    # Play new game of Recursive Combat if necessary.
    if decks[0].length >= zero && decks[1].length >= one
      new_decks = [ decks[0][0, zero].dup, decks[1][0, one].dup ]
      winner = sub_game(new_decks, game+1)
    else
      # Otherwise, the winner of the round is the player with the higher card.
      winner = (zero > one) ? 0 : 1
    end
    
    # The winner takes the two cards and adds them at the end of their deck.
    (winner == 0) ? decks[0] << zero << one : decks[1] << one << zero
  end

  decks
end

# Get winning deck of second round and score it.
winning = second_round(decks, 1).find { |d| d.length > 0 }
puts score(winning)
