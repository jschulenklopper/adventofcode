grid = Hash.new { |hash,key| hash[key] = 0 }
ARGF.readlines.each.with_index { |line,x|
    line.strip.chars.each.with_index { |r,y| grid[ [y,x] ] = r.to_i } }

def neighbors(grid, node)
  # Calculate neighbors of node in grid.
  [ [-1,0], [0,-1], [0,+1], [+1,0] ]  # Valid deltas for neighbors of `node`.
    .map { |d| [ node[0]+d[0], node[1]+d[1] ] }
    .filter { |k| grid.key?(k) }
end

def expand(grid)
  size_x, size_y = grid.keys.sort.max[0]+1, grid.keys.sort.max[1]+1
  expanded_grid = {}

  5.times do |dx| 5.times do |dy| grid.each do |key,_|
    new_key = [dx * size_x + key[0], dy * size_y + key[1]]
    new_value = (grid[ [key[0],key[1]] ] + dx + dy)
    new_value -= 9 if new_value > 9  # Wrap value if above 9.
    expanded_grid[new_key] = new_value
  end end end

  expanded_grid
end

def cheapest_path(grid, start, goal)
  # Prepare queue and visited data structures.
  # Queue is a list of grid positions, actual and expected costs.
  queue = [{ :key => start, :cost => 0 }]
  # Visited is a grid (hash) of grid positions and actual costs to get there.
  visited = { start => 0 } # { node => cost }

  # Loop until queue empty; take front of queue.
  while node = queue.shift do
    # Add to visited list
    visited[node[:key]] = node[:cost]

    break if node[:key] == goal

    # Get neighbors that haven't been visited yet.
    neighbors = neighbors(grid, node[:key]).filter { |key| ! visited.include?(key) }

    neighbors.each do |neighbor|
      # Compute cost of getting here. 
      cost = grid[neighbor] + node[:cost]

      # Add to queue, if it's not already in there.
      new_node = { :key => neighbor, :cost => cost }

      unless queue.any? { |q| q[:key] == new_node[:key] && q[:cost] <= new_node[:cost] }
        queue << new_node
      end
    end

    # Sort queue on total cost.
    queue.sort! { |node1, node2| (node1[:cost]) <=> (node2[:cost]) }
  end

  # Return the cost of the goal node.
  visited[goal]
end

puts "part 1"
puts cheapest_path(grid, [0,0],  grid.keys.sort.max)

puts "part 2"
expanded_grid = expand(grid)
puts cheapest_path(expanded_grid, [0,0],  expanded_grid.keys.sort.max)
