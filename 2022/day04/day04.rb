assignments = ARGF.readlines.map { |line|
  line.strip.split(",").map { |pair|
    ranges = pair.split("-").map(&:to_i)
    Range.new(ranges[0], ranges[1]).to_a
  }
}

puts "part 1"
count = assignments.count do |one, two|
  [one.length, two.length].include? (one & two).length
end
puts count

puts "part 2"
count = assignments.count do |one, two|
  (one & two).length > 0
end
puts count
