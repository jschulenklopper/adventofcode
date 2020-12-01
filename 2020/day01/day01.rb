entries = ARGF.readlines.map(&:to_i)

puts "part 1"
puts entries.combination(2).select { |a| a.reduce(:+) == 2020 }.flatten.reduce(:*)

puts "part 2"
puts entries.combination(3).select { |a| a.reduce(:+) == 2020 }.flatten.reduce(:*)
