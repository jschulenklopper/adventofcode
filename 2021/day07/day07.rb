positions = ARGF.readline.split(",").map(&:to_i).sort  # NOTE Sort it now.
l = positions.length

# Compute median position.
median = (positions[(l - 1) / 2] + positions[l / 2]) / 2

puts "part 1"
puts positions.map { |position|
  (position - median).abs  # Fuel to move to median.
}.sum  # Sum all the individual fuel needs.

puts "part 2"
# For all possible 'medians'
puts (positions.first .. positions.last).map { |median|
  # ... for each of the positions
  positions.map { |position|
  # ... compute the required fuel for each crab
    # ... with the formula for triangular numbers
    distance = median - position
    distance.abs * (distance.abs + 1) / 2
  # ... then sum the fuel needs
  }.sum
# ... and finally take the lowest.
}.min
