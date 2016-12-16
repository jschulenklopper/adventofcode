# Next to representation of the state of the factory, it is also
# a representation of (the resulting state after) a move.
class Factory < Hash
  attr_accessor :floors    # Hash with contents of floors.
  attr_accessor :at        # Position of elevator: 1st floor
  attr_accessor :cost      # Some value for cost of getting to this state.
  attr_accessor :distance  # Some value for estimated remaining distance to goal.
  attr_accessor :goal      # Floor level to reach.

  def initialize
    @floors = Hash.new
  end

  def duplicate
    Marshal.load(Marshal.dump(self))  # Seems trickery for a deep copy.
  end

  def ==(other_factory)
    Marshal.dump(self) == Marshal.dump(other_factory)
  end

  def set_cost
    @cost = 0  # TODO Add some measure of the cost of the last step.
  end

  def distance!
    dist = 0
    # Compute distance of objects to goal floor.
    @floors.keys.each do |floor|
      dist += @floors[floor].length * 2**(floor - @goal).abs
    end
    @distance = dist
  end

  def objects
    objects = []
    @floors.keys.each do |floor|  # TODO Perhaps a cleaner collect could do.
      objects += @floors[floor]
    end
    objects
  end

  def valid?
    # Assume that the factory is valid.
    valid = true
    # But examine each floor...
    @floors.each do |floor, items|
      # Create list of materials for generators and chips.
      # First select on type (G or M), then select materials (first two characters).
      gen_materials = items.select { |t| t[2] == "G" }.map { |m| m[0,2] }
      chip_materials = items.select { |t| t[2] == "M" }.map { |m| m[0,2] }
      # Create list of all combinations generator-chip.
      combis = gen_materials.product(chip_materials)
      # See whether there are unprotected chips.
      combis.select! { |gen, chip| (gen != chip) && !combis.include?([chip, chip]) }
      valid = false if combis.length > 0
    end
    valid
  end

  def goal_reached?
    self.objects.length == @floors[@goal].length  # Are all objects on goal floor?
  end

  def possible_moves
    # Get list of possible locations for elevator: one above/below current floor..
    possible_floors = @floors.keys.select { |f| [@at+1,@at-1].include?(f) }
    # Get list of item combinations that may be moved.
    possible_loads = (1..2).flat_map { |size| @floors[@at].combination(size).to_a }
    # Create a list of possible future states.
    possible_changes = possible_floors.product(possible_loads)
    possible_moves = possible_changes.map do |new_floor, items|
      move = self.duplicate  # Duplicate current factory state.
      
      items.each { |item| move.floors[move.at] -= [item] }  # Remove the items from one floor.
      move.at = new_floor
      items.each { |item| move.floors[move.at] += [item] }  # ... and at it to the other.
      
      # Set distance on this move.
      move.distance!
      move
    end
    possible_moves
  end

  def valid_moves
    possible_moves.select { | move| move.valid? }
  end

  def to_s
    # Create a list of all columns (one object per column).
    columns = []
    @floors.each { |nr, contents|
      columns += contents
    }

    # Print header line.
    string = "====" * (columns.length + 1)

    # Starting from the top floor, print the details per floor.
    @floors.keys.reverse.each do |floor|
      string += "\nF%d " % [floor]
      string += (@at == floor) ? "E " : "  "
      columns.sort.each do |object|
        string += (@floors[floor].include?(object)) ? object + " " : " .  "
      end
    end

    # Print footer line, with some stats.
    string += "\n" + "----" * (columns.length + 1)
    string += "\ncost: %3d, dist: %3d" % [@cost, @distance]
    string += "\n\n"
  end

end

factory = Factory.new
path = Array.new   # A list of factory states, representing actual moves.
queue = Array.new  # A list of moves possibly to be made.
visited = Array.new   # A list of states already considered.

# Read the input file, set up the factory.
floor = 0
while line = gets do
  floor += 1

  line.match(/floor contains (?<parts>.*)$/) do |match|
    parts = match[:parts]

    factory.floors[floor] = Array.new

    objects = parts.scan(/(?<material>[a-z\-]+) (?<object>(microchip)|(generator))/)

    objects.each do |object|
      factory.floors[floor] << object[0][0,2].capitalize + object[1][0,1].capitalize
    end
  end
end

factory.at = 1          # The elevator starts at the first floor.
factory.cost = 0        # It was cheap to get here.
factory.goal = 4        # This is where all things need to go to.

factory.distance!    # Compute distance for current state.

# First try it with BFS. Then later promote the logic to A*.

# Add start situation to queue, and path (being start situation).
queue = [ [factory, [factory]] ]

while ! queue.empty?
  # Get new state from queue.
  queue.sort! { |a, b| a[0].distance <=> b[0].distance }
  current_state, path = queue.shift

  # If we haven't seen this before...
  if ! visited.include?(current_state)
    # ... add it to the list of visited states.
    visited << current_state

    # Check if state is goal.
    if current_state.goal_reached?
      "goal reached"
      break
    end

    # Add all possible next valid moves to queue, if we haven't seen these earlier.
    possible_moves = current_state.valid_moves.reject do |f|
      visited.include?(f)
    end
    possible_moves.each do |f|
      queue.push([f, path + [f]])
    end
  end
end

if path.last.goal_reached?
  puts path.length - 1

  puts "steps"
  path.each_with_index do |f, index|
    puts index
    puts f
  end
else
  puts "no solution"
end
