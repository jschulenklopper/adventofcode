lists = [[],[]]
ARGF.readlines.each do |l|
  numbers = l.strip.split.map { |i| i.to_i }
  lists[0] << numbers[0]
  lists[1] << numbers[1]
end

# Part 1
distance = 0

lists.each do |l|
  l.sort!
end

lists[0].each.with_index do |n, i|
  distance += (n - lists[1][i]).abs
end

puts distance

# Part 2
similarity = 0

lists[0].each do |n|
  p often = lists[1].count(n)
  similarity += n * often
end

puts similarity
