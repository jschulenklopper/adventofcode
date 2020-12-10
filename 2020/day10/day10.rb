adapters = ARGF.readlines.map(&:to_i)

puts "part 1"

# Add charging outlet and sort adapters.
adapters << 0
adapters.sort!

# Build map of differences between successive elements.
differences = adapters.map.with_index { |adapter, index| 
  if index < adapters.length - 1
    adapters[index+1] - adapter 
  else
    3
  end
}

# Make tally of differences.
tally = differences.tally

# Multiply frequencies of individual differences.
puts tally.reduce(1) { |total, element| total *= element[1] }
