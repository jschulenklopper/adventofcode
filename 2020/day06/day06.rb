groups = ARGF.read.split("\n\n").map(&:split)

puts "part 1"
puts groups.map { |group| group.join.chars.uniq.length }.sum

puts "part 2"
puts groups.map { |group| group.map(&:chars).reduce(&:&).length }.sum
