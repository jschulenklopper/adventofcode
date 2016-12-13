class Maze  # A collection of cells.
  attr_reader :cells  # Hash of cells, identified by their [x,y] coordinate as key.
  attr_reader :input  # Input value, used to generate maze.

  def initialize(input)
    @cells = Hash.new
    @input = input
  end

  def add_cell(location)  # Returns the cell that is generated.
    x, y = location[0], location[1]
   
    return nil if x < 0 || y < 0  # Don't create cell that's outside bounds.

    return @cells[location] if @cells[location]  # Return cell if it is already in maze.

    # Create cell.
    value = x*x + 3*x + 2*x*y + y + y*y + @input
    number_of_1_bits = value.to_s(2).chars.count("1")
    @cells[location] =
      if (number_of_1_bits.even?)
        then Cell.new("open", location)  # TODO Perhaps location isn't necessary.
        else Cell.new("wall", location)
      end
  end

  def neighbor_locations(location)  # Returns list of neighbor locations.
    x,y = location[0], location[1]
    locations = []
    locations.push([x-1,y]) if x-1 >= 0
    locations.push([x+1,y])
    locations.push([x,y-1]) if y-1 >= 0
    locations.push([x,y+1])
    locations
  end

  def add_neighbors(location)
    neighbor_locations(location).map { |l| add_cell(l) }
  end
end

class Cell
  attr_reader :type  # "." for open (space), "#" for wall.
  attr_reader :location  # [x,y] TODO Perhaps this isn't necessary.
  attr_accessor :distance  # Distance from start.

  def initialize(type, location)
    @location = location  # TODO Is this necessary?
    @type = (type == "open") ? "." : "#"
    @distance = 0
  end

  def to_s
    @type
  end

  def open?
    type == "."
  end

  def wall?
    type == "#"
  end
end

# Process input.
input = 0
goal = []
while line = gets do
  line.match(/^input: (?<input>\d+)/) do |match|
    input = match[:input].to_i
  end
  line.match(/^goal: (?<x>\d+),(?<y>\d+)/) do |match|
    goal[0] = match[:x].to_i
    goal[1] = match[:y].to_i
  end
end

maze = Maze.new(input)
size = [goal[0] * 2, goal[1] * 2]
max_distance = 50
  
# Find path from [1,1].
start = maze.add_cell([1,1])
start.distance = 0

queue = Array.new        # List of unprocessed cells.
visited = Array.new      # List is processed cells.
within_reach = Array.new # List of cells within specific distance.

queue.push(start)  # Start the queue with the starting cell.

# Continue until queue is empty.
until queue.empty? do
  # Get cell from queue, add it to visited.
  current = queue.shift
  within_reach.push(current)

  visited.push(current)

  # Get, possibly create, neighbors of current.
  neighbors = maze.add_neighbors(current.location)

  # Filter open cells.
  open = neighbors.select { |c| c.open? }

  # Consider each open, neighboring cell, and add it to the queue.
  open.each do |c|
    # Only add it to queue and visited list if it isn't there yet.
    if !visited.include?(c) && !queue.include?(c)
      c.distance = current.distance + 1
      # Add it to queue if cell is within reach.
      if c.distance <= max_distance
        queue.push(c)
      end
    end
  end
end

puts within_reach.length
