depths = ARGF.readlines.map(&:to_i)

puts "part 1"
# For all consecutive pairs, select only values larger than the previous one.
puts depths.each_cons(2).select { |first, second| second > first }.length

# Sum depth measurements in windows of length 3.
windows = depths.each_cons(3).map { |a| a.sum }

puts "part 2"
# Select only the measurement windows larger than the previous one.
puts windows.each_cons(2).select { |first, second| second > first }.length
