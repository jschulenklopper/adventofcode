$rules = ARGF.readlines.map do |line|
  # Split bag and contents.
  bag, contents = line.split(" contain ")
  # Get color of container.
  color = bag.match(/(.+) bags/).captures.first
  # Get colors of contained bags.
  contained = contents.scan(/([\w ]+) bag/).flatten.map(&:strip)
  colors = contained.map { |bag| bag.match(/([no\d]+)? (.+)/).captures}
  # Remove contained bags that were accidentally included.
  colors.reject! { |color| color[0] == "no" } # TODO Perhaps it's not necessary to remove this.
  [color, colors]  # [container, contents]
end

puts "part 1"

# Count the number of bags that can contain bag.
def can_contain(bag)
  # Find bags that can be inside bag.
  bags = $rules.select { |_, inside|
    inside.select { |_, color| color == bag }.length > 0
  }.map(&:first)

  # Find bags that can be inside all those bags.
  inside = bags.map { |color| can_contain(color) }

  # Add those two lists. TODO Return just the length.
  (bags + inside.flatten).uniq
end

puts can_contain("shiny gold").length

puts "part 2"

# Count the number of bags that can be inside bag.
def count_contain(bag)
  # Find bags that can be inside bag.
  bags = $rules.select { |outside, _| (bag == outside) }.map(&:last).first

  bags.map.reduce(1) { |sum, bag| sum += bag[0].to_i * count_contain(bag[1]) } if bags
end

# Subtract 1 to 
puts count_contain("shiny gold") - 1
