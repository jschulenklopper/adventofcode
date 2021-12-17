numbers = ARGF.readlines.map(&:strip).map(&:chars)

# Quick way to calculate gamma: tally the 0's and 1's,
# determine the most common bit. Then join those and convert to integer.
gamma = numbers.transpose.map do |number|
  number.tally.key(number.tally.invert.keys.max)
end.join.to_i(2)

# Likewise for epsilon, the least common bit in every position in number.
epsilon = numbers.transpose.map do |number|
  number.tally.key(number.tally.invert.keys.min)
end.join.to_i(2)

puts "part 1"
puts gamma * epsilon

# Make specific sort function for a tally.
def sort_tally(a, b, direction)
  direction * ([a[1], a[0]] <=> [b[1],b[0]])
end

# Find rating.
def rating(numbers, dir)
  numbers.first.length.times do |i|
    # Find most/least common bit on position i.
    tally = numbers.map { |n| n[i] }.tally
    most = tally.to_a.sort { |a,b| sort_tally(a,b,dir) }.last
    # Reject the numbers not matching the most/least common bit.
    numbers.reject! { |n| n[i] != most[0] }
  end
  numbers.join.to_i(2)
end

puts "part 2"
oxygen = rating(numbers.dup, 1)
co2 = rating(numbers.dup, -1)
puts oxygen * co2
