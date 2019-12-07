# Read list of orbiting objects.
orbits = ARGF.readlines.map { |line| line.strip.split(")") }

# Transform list of orbits to tree.
def tree(orbits, root)
  children = orbits.select { |o| o[0] == root }.map { |o| o[1] }
  if children.length > 0
    [root, children.map { |c| tree(orbits, c) } ]
  else
    [root]
  end
end

# Compute cummulative length of all possible paths through tree.
def count_paths(length_so_far, tree)
  if tree[1]
    length_so_far += tree[1].map { |t| count_paths(length_so_far+1, t) }.reduce(&:+)
  else
    length_so_far
  end
end

puts count_paths(0, tree(orbits, "COM"))