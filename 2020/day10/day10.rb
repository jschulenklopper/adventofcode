adapters = ARGF.readlines.map(&:to_i)

puts "part 1"

# Add charging outlet, sort adapters and add device.
adapters << 0
adapters.sort!
adapters << adapters.max + 3

# Build map of differences between successive elements.
differences = adapters[0,adapters.length-1].map.with_index { |adapter, i| 
  adapters[i+1] - adapter 
}

# Make tally of differences.
tally = differences.tally

# Multiply frequencies of individual differences.
puts tally.reduce(1) { |total, element| total *= element[1] }
