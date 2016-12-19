require 'digest'

# grid = Array.new(4) { |r| r = Array.new(4) }
GRID_SIZE = 4

def goal_reached(node)
  (node == [3,3]) ? true : false
end

def get_possible_moves(input, node, path)
  hash = Digest::MD5.hexdigest(input + path)[0,4]

  directions = ["U", "D", "L", "R"]
  moves = Hash.new

  directions.each_with_index do |dir, i|
    if %w{b c d e f}.include?(hash[i])
      case dir
        when "U"
          moves["U"] = [  node[0], node[1] - 1] if node[1] - 1 >= 0
        when "D"
          moves["D"] = [  node[0], node[1] + 1] if node[1] + 1 < GRID_SIZE
        when "L"
          moves["L"] = [ node[0] - 1,  node[1] ] if node[0] - 1 >= 0
        when "R"
          moves["R"] = [ node[0] + 1,  node[1] ] if node[0] +1 < GRID_SIZE
      end
    end
  end 
  moves
end

def solve_maze(input)
  start_node = [0,0]
  start_path = ""  # String of directions; UDLR's and such.

  queue = [ [start_node, start_path] ]  # Elements in array: [node, path to node].

  solutions = []

  while !queue.empty?
    # puts "queue.length: %d" % queue.length

    current_node, path = queue.shift

    if goal_reached(current_node)
      solutions << path
      # puts "  solutions.length: %d" % solutions.length
      next
    end

    moves = get_possible_moves(input, current_node, path)

    moves.each do |direction, node|
      queue.push( [ node, path + direction ] )
    end
  end

  return solutions
end

while line = gets
  input = line.strip

  # This is a comment line in the input.
  next if input[0] == "#"
  next if input.length == 0

  solutions = solve_maze(input)
  max_length = 0
  solutions.each do |s|
    if s.length > max_length
      max_length = s.length
    end
  end
  puts max_length
end
