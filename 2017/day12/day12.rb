require 'set'

def reach(programs, id)
  reach = []

  # Process id via a breadth-first search (thus a queue).
  queue = [id]
  while node = queue.shift
    # Add current node to reach.
    reach << node
    ## Add connected nodes to queue, unless it's already in reach or in queue.
    programs[node].each { |n| queue.push(n) unless reach.include?(n) || queue.include?(n)}
  end

  # Sorting the items will ignore differences in order.
  reach.sort
end

programs = Hash.new { |k,v| Set.new }

# Build representation of network.
while line = gets
  # Read left and right part from line.
  from, dest = line.split("<->").map(&:strip)
  # Add all destinations to `from`, and `from` to all destinations.
  # Converting the ids to ints speeds things up considerably.
  dest.split(", ").each do |to|
    programs[from.to_i] += [to.to_i] 
    programs[to.to_i] += [from.to_i] # Not really necessary, but it's in spec.
  end
end

# Build groups of connected programs.
groups = Set.new
programs.each { |node, _list|
  # Find all the nodes to be reached from node.
  group = reach(programs, node)
  # Add that list to groups (but only if it's a new one; via the set).
  groups.add(group)
}

puts "size of group %s: %s" % [0, reach(programs, 0).length]
puts "number of groups: %s" % groups.length