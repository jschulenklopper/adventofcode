depths = ARGF.readlines.map(&:to_i)

puts "part 1"
# Select only the measurements larger than the previous measurement.
puts depths.select.with_index { |depth, i|
  depth > depths[i-1] && i > 0
}.length


# Build a list of measurement windows.
windows = depths.map.with_index { |depth, i|
  depths[i-2, 3].sum
}

puts "part 2"
# Select only the measurement windows larger than the previous one.
puts windows.select.with_index { |depth, i|
  depth > windows[i-1] && i > 2
}.length
