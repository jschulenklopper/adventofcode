positions = ARGF.readline.split(",").map(&:to_i)

sorted = positions.sort
length = positions.length

# Compute median position.
median = ((sorted[(length - 1) / 2] + sorted[length / 2]) / 2.0).floor

# Compute fuel required to move to median position.
puts "part 1"
puts positions.reduce(0) { |memo, position| memo += (position - median).abs }

# Compute fuel to cover distance.
def fuel(distance, steps=1)
  (distance == 0) ? 0 : fuel(distance-1, steps+1) + steps
end

puts "part 2"
# For all possible 'medians'
puts (sorted.first .. sorted.last).map { |m|
  # ... for each of the positions
  positions.map { |p|
  # ... compute the required fuel for each crab
    fuel( (m-p).abs )
  # ... sum the fuel
  }.sum
# ... and take the lowest cost.
}.min
