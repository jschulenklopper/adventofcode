entries = ARGF.readlines.map(&:to_i)


puts "part 1"
puts entries.combination(2).find { |a| a.sum == 2020 }.reduce(:*)


puts "part 2"
puts entries.combination(3).find { |a| a.sum == 2020 }.reduce(:*)
