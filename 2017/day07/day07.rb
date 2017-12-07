def weigh_tree(programs, id, level = 0)
  node = programs[id]

  if node[1] == []
    # If there are no subtrees, just store the node's weight.
    node.push(node[0])
  else
    # Otherwise, store the weight plus the combined weight of subtrees.
    node.push(node[1].reduce(node[0]) { |sum, n| sum + weigh_tree(programs, n, level + 1) })
  end

  # Try to find any imbalance. Build a frequency table of all the weights.
  counts = node[1].map { |id| programs[id][2]}.each_with_object(Hash.new(0)) { |c, h| h[c] += 1 }
  # If there's more than one diferent weight, there's an imbalance.
  if counts.size > 1
    # Find the imbalanced node; the one with a unique weight of the subtrees' weights.
    imbalanced = programs.keys.select { |id| programs[id][2] == counts.key(1) }.first
    puts "imbalance in: %s" % imbalanced
    # Find the wrong weight (with occurrence 1) and the correct weights (not 1).
    wrong_weight = counts.select { |k,v| v == 1}.keys.first
    correct_weight = counts.reject { |k,v| v == 1}.keys.first
    # Calculate necessary correction.
    diff = wrong_weight - correct_weight
    puts "necessary correction: %s" % diff
    # Calculate what weight of imbalanced node needs to be.
    corrected_weight = programs[imbalanced][0] - diff
    puts "corrected_weight: %s" % corrected_weight
    # Register the corrected weight (and the corrected total weight).
    programs[imbalanced][0] = corrected_weight
    programs[imbalanced][2] -= diff
    exit
  end

  return node[2]
end

# Read input file and build data structure.
$programs = {}
while line = gets
  line.match(/^(?<id>\w+)\s+\((?<weight>\d+)\)(\s+->\s(?<above>.*))?/) do |match|
    # Find the list (if there is one) of programs about the current one.
    on_top = (match[:above]) ? match[:above].split(", ") : []
    # Store the program with its weight and connected nodes.
    $programs[match[:id]] = [match[:weight].to_i, on_top]
  end
end

# First, find the root of the tree. Make a list of all nodes above another node...
above = $programs.values.reject { |p| p[1] == [] }.map { |p| p[1] }.flatten
# ... and find the node that is not in that list.
root = $programs.select { |p| not above.include?(p) }.keys.first
puts "root: %s" % root

# Starting with the root, recursively calculate weights of subtrees above.
weigh_tree($programs, root)
