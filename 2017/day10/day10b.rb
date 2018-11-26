MAX = 256
ROUNDS = 64

def hash(input, start, skip, lengths)
  lengths.each do |length|
    # Rotate string to start.
    input = input.rotate(start)
    # Input becomes reversed part plus remainder.
    input = input[0, length].reverse + input[length..-1]
    # ... and then rotate it backwards again.
    input = input.rotate(-1 * start)

    # Move start position, increase skip length.
    start = (start + length + skip) % input.length
    skip = (skip + 1)
  end

  # Return output and new start and skip values.
  [input, start, skip]
end

# Form list, from 0 to MAX
list = (0...MAX).to_a

# Read lengths from stdin and add the suffix.
bytes = gets.strip.chars.map(&:ord) + [17, 31, 73, 47, 23]

current = 0
skip_size = 0

# Perform the required number of hashes.
ROUNDS.times do
  list, current, skip_size = hash(list, current, skip_size, bytes)
end

# Make groups of 16 elements, XOR all elements in group, represent group as hex string.
puts list.each_slice(16).map { |s| s.reduce(&:^).to_s(16) }.join