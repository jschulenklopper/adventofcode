lines = ARGF.readlines.map(&:strip)

instructions = Array.new
DECK_SIZE = 10007
cards = (0...DECK_SIZE).map(&:to_i)

# Build list of instructions.
lines.each do |line|
  if match = line.match(/deal into new stack/)
    instructions << lambda { |deck| deck.reverse }
  elsif match = line.match(/cut (-?\d+)/)
    n = match.captures.first.to_i
    instructions << lambda { |deck| deck.rotate(n) }
  elsif match = line.match(/deal with increment (-?\d+)/)
    n = match.captures.first.to_i
    instructions << lambda { |deck| 
      new_deck = Array.new(deck.length)
      pos = 0
      deck.each { |card|
        new_deck[pos] = card
        pos = (pos + n) % deck.length
      }
      new_deck
    }
  end
end

# Perform list of instructions.
instructions.each do |instruction|
  cards = instruction.call(cards)
end

puts cards.index(2019)