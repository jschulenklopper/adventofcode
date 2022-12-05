rucksacks = ARGF.readlines.map(&:strip)

priorities = [""] + ("a".."z").to_a + ("A".."Z").to_a

puts "part 1"
scores = rucksacks.map do |items|
  first, second = items[0.. -1+items.length/2], items[items.length/2..-1]
  common_item = first.split("") & second.split("")
  priorities.index(common_item.join)
end
puts scores.sum

puts "part 2"
score = 0
rucksacks.each_slice(3) do |group|
  common_item = group[0].split("") & group[1].split("") & group[2].split("")
  score += priorities.index(common_item.first)
end
puts score
