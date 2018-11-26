MAX = 256

def hash(input, start, skip, lengths)
  lengths.each do |length|
    input = input.rotate(start)     # Rotate string to start.
    rev = input[0, length].reverse  # Part to be reversed.
    rem = input[length..-1]         # Last part, unaffected.
    input = rev + rem
    input = input.rotate(-1 * start) # Rotate it backwards to original.

    # Move start position, increase skip length.
    start = (start + length + skip) % input.length
    skip = (skip + 1) # % input.length
  end

  input
end

# Form list, from 0 to MAX
list = (0...MAX).to_a

# Read lengths from stdin
lengths = gets.split(",").map(&:to_i)

current = 0
skip_size = 0

hashed = hash(list, current, skip_size, lengths)
puts hashed[0] * hashed[1]