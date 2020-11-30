def dfs(start, goal, f_moves)
  stack = [start]
  
  while true do
    current = stack.shift

    return false if current == nil
    return true if current == goal

    if f_moves.is_a? Proc
      next_nodes = f_moves.call(current).reverse.each { |node| stack.unshift(node) }
    else
      next_nodes = method(f_moves).call(current).reverse.each { |node| stack.unshift(node) }
    end
  end
end


def bfs(start, goal, f_moves)
  queue = [start]
  
  while true do
    current = queue.shift

    return false if current == nil
    return true if current == goal

    if f_moves.is_a? Proc
      next_nodes = f_moves.call(current).each { |node| queue.push(node) }
    else
      next_nodes = method(f_moves).call(current).each { |node| queue.push(node) }
    end

  end
end

# Different ways to specify functions that generate moves.

DEPTH = 10
WIDTH = 10

# Specify a function to generate next moves.
def dot_moves(node)
  moves = []
  unless node.length > DEPTH
    nr_nodes = WIDTH
    nr_nodes.times { |n| moves << node + "." + (n+1).to_s }
  end
  moves
end


# Declare a Proc to generate next moves.
dash_moves = Proc.new do |node| 
  moves = []
  unless node.length > DEPTH
    nr_nodes = WIDTH
    nr_nodes.times { |n| moves << node + "-" + (n+1).to_s }
  end
  moves
end

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
t1 = Time.now
puts bfs("1", "1.3.4", :dot_moves)
puts Time.now - t1
t1 = Time.now
puts bfs("1", "1-3-4", dash_moves)
puts Time.now - t1
t1 = Time.now
puts bfs("1", "1/3/4", slash_moves)
puts Time.now - t1

# Testing depth-first search.
puts "DFS"
t1 = Time.now
puts dfs("1", "1.3.4", :dot_moves)
puts Time.now - t1
t1 = Time.now
puts dfs("1", "1-3-4", dash_moves)
puts Time.now - t1
t1 = Time.now
puts dfs("1", "1/3/4", slash_moves)
puts Time.now - t1

