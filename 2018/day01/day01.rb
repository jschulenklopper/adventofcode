# Get the whole input file, split at newlines,
# convert to integers, and reduce array by adding all values.
puts gets(nil).split("\n").map(&:to_i).reduce(0,&:+)

# More straightforward approach:
# freq = 0  # Start frequency.

# while line = gets
#   freq += line.strip.to_i  # Add delta to frequency.
# end

# puts freq