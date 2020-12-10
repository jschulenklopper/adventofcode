p adapters = ARGF.readlines.map(&:to_i)

puts "part 1"

# Add charging outlet
adapters << 0

# Sort adapters.
sorted = adapters.sort

# Build map of differences between successive elements.
differences = sorted.map.with_index { |adapter, index| 
  if index < sorted.length - 1
    sorted[index+1] - adapter 
  else
    3
  end
}

# Make tally of differences.
tally = differences.tally

# Multiply frequencies of individual differences.
puts tally.reduce(1) { |total, element| total *= element[1] }
