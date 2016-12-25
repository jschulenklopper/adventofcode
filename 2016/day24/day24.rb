class Maze < Array
  attr_reader :rows, :cols

  def initialize
    @grid = Array.new
    @rows = 0
    @cols = 0
  end

  def set_size
    @rows = self.length
    @cols = (self.length > 0) ? self.first.length : 0
  end

  def neighbors(cell)
    x, y = cell.position[0], cell.position[1]
    neighbors = []
    neighbors << self[y][x+1] if y.between?(0,@rows-1) && (x+1).between?(0,@cols-1)
    neighbors << self[y][x-1] if y.between?(0,@rows-1) && (x-1).between?(0,@cols-1)
    neighbors << self[y+1][x] if (y+1).between?(0,@rows-1) && x.between?(0,@cols-1)
    neighbors << self[y-1][x] if (y-1).between?(0,@rows-1) && x.between?(0,@cols-1)
    neighbors.select { |n| ! n.wall? }
  end

  # Return the length of the shortest path between start and goal.
  def shortest_path_length(start, goal)
    queue = [ [start,0] ]

    while ! queue.empty?
      current, length = queue.shift
      
      if current == goal
        return length
      end

      neighbors = self.neighbors(current)
      neighbors.each do |neighbor|
        queue << [ neighbor, length+1] if !queue.map { |c,l| c }.include?(neighbor)
      end

    end

    return nil
  end
end

class Cell
  attr_accessor :type
  attr_accessor :position
  attr_accessor :neighbors
  attr_accessor :previous  # Used in paths of cells.

  def initialize(cell, position)
    @type = cell
    @position = position
    @neighbors = []
  end

  def to_s
    type.to_s
    # @neighbors.length
  end

  def wall?
    type == "#"
  end

  def open?
    type == "."
  end

  def location?
    ! open? && ! wall?
  end

  def location
    if location?
      type
    else
      nil
    end
  end
end

maze = Maze.new

# Read the maze from the input file.
y = 0
while line = gets
  x = 0
  row = Array.new
  line.strip.chars.each do |c|
    row << Cell.new(c, [x,y])
    x += 1
  end
  maze << row
  y += 1
end

maze.set_size

# Find the locations in the maze.
locations = []
y = 0
maze.each do |row|
  x = 0
  row.each do |cell|
    locations << cell if cell.location?
    x += 1
  end
  y += 1
end

# Sort locations, so that '0' is in front of array.
locations.sort! { |a,b| a.type <=> b.type }

# Make pairs of all locations.
pairs = locations.combination(2).map

# Find the shortest path between each of the locations.
distances = {}
pairs.map do |from, to|
  length = maze.shortest_path_length(from, to)
  distances[[from,to]] = length
  distances[[to,from]] = length
end

# Make all permutations (possible orders) of locations.
# Find total length of path, find shortest.

# Pick a starting location for all paths.
first = locations.shift  # Take the first one.
possible_paths = locations.permutation.map { |p| [first] + p + [first] }
# possible_paths = locations.permutation.map { |p| [first] + p + [first] } # Part 2.

lengths = possible_paths.map do |path|
  length = 0
  (0..path.length-2).each do |start|
    if distance = distances[[path[start], path[start+1]]]
      length += distance
    end
  end
  length
end

puts lengths.min
