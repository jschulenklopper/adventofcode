decks = ARGF.readlines.join(",").          # Read the decks of the players.
             split(/Player \d:/).          # Split decks between players.
             map { |s| s.split(",").map(&:to_i) }.  # Make arrays of integers.
             select { |a| not a.empty? }.  # Remove empty deck (first one).
             map { |a| a.delete(0); a }    # Remove all zeros from decks.

puts "part 1"

until decks[0].length == 0 || decks[1].length == 0
  zero, one = decks[0].shift, decks[1].shift
  (zero > one) ? decks[0] << zero << one : decks[1] << one << zero
end

# Select winning deck.
winning = decks.find { |d| d.length > 0 }
# Compute score of winning deck.
puts winning.reverse.map.with_index { |card, i| (i+1) * card }.sum
