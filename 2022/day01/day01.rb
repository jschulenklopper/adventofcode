# Read and add the number of calories that every elve carries.
calories = ARGF.read.split("\n\n").map { |s| s.split("\n").map(&:to_i).sum }

puts "part 1"
puts calories.max

puts "part 2"
puts calories.sort.reverse[0..2].sum

