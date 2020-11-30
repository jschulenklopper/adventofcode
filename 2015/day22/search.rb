def dfs(start, goal, f_moves)
  stack = [start]
  solutions = []
  
  while current = stack.shift do
    solutions << current if current.match(goal)

    next_nodes = f_moves.call(current).reverse.each { |node| stack.unshift(node) }
  end
  solutions
end


def bfs(start, goal, f_moves)
  queue = [start]
  solutions = []
  
  while current = queue.shift do
    solutions << current if current.match(goal)

    next_nodes = f_moves.call(current).each { |node| queue.push(node) }
  end
  solutions
end

# Different ways to specify functions that generate moves.

DEPTH = 10
WIDTH = 10

# Declare a Lambda to generate next moves.
slash_moves = lambda do |node|
  moves = []
  unless node.length > DEPTH
    nr_nodes = WIDTH
    nr_nodes.times { |n| moves << node + "/" + (n+1).to_s }
  end
  moves
end


# Testing breadth-first search.
puts "BFS"
puts bfs("1", "1/3/4", slash_moves)

# Testing depth-first search.
puts "DFS"
puts dfs("1", "1/3/4", slash_moves)

# Collect nodes matching condition.
puts "Collect all"
puts bfs("1", "1/3/4", slash_moves)
puts dfs("1", "1/3/4", slash_moves)

