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

def contain(bag)
  # Find bags that can be inside bag.
  bags = $rules.select { |outside, inside|
    inside.select { |nr, color| color == bag }.length > 0
  }.map(&:first)
  # Find bags that can be inside all those bags.
  inside = bags.map { |color| contain(color) }
  # Add those two lists.
  (bags + inside.flatten).uniq
end

puts contain("shiny gold").length
