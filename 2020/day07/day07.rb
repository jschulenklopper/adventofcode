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

def containers_of(bag)
  # Find bags where bag can be inside of.
  containers = $rules.select { |outside, inside|
    inside.select { |nr, color| color == bag }.length > 0
  }
  first = containers.map(&:first)
  # Find bags where those bags can be inside of.
  more = first.map { |color| containers_of(color) }.flatten.uniq
  # Add those two lists.
  first + more
end

puts containers_of("shiny gold").length
