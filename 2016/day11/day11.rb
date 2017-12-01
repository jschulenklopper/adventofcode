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
    # Consider two factories equal if the sorted items per floor are equal.
    self_string =  "E" + @at.to_s + @floors.map { |f,i| f.to_s + i.sort.join }.join
    other_string = "E" + other_factory.at.to_s + other_factory.floors.map { |f,i| f.to_s + i.sort.join }.join
    return true if self_string == other_string

    # Consider two factories equal if number of unique elements per floor are equal.
    self_memo = Array.new
    self_compressed = "E" + @at.to_s + @floors.map { |floor, items|
      "-" + floor.to_s + ":" +
        items.map { |item|
          if ! self_memo.find_index(item[0,2])
            self_memo << item[0,2]
          end
          self_memo.find_index(item[0,2])
        }.length.to_s  # sort.uniq.join
    }.join

    other_memo = Array.new
    other_compressed = "E" + other_factory.at.to_s + other_factory.floors.map { |floor, items|
      "-" + floor.to_s + "-" +
        items.map { |item|
          if ! other_memo.find_index(item[0,2])
            other_memo << item[0,2]
          end
          other_memo.find_index(item[0,2])
        }.length.to_s  # sort.uniq.join
    }.join

    return true if self_compressed == other_compressed

    return false
  end

  def distance!
    dist = 0
    # Compute distance of objects to goal floor.
    @floors.select { |floor, items| dist += items.length * (floor - @goal).abs }
    @distance = dist
  end

  def objects
    list = []
    @floors.select { |floor, items| list += items }
    list
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
    # puts "possible_moves"
    # Get list of possible locations for elevator: one above/below current floor..
    possible_floors = @floors.keys.select { |f| [@at+1,@at-1].include?(f) }
    # Get list of item combinations that may be moved.
    possible_loads = (1..2).flat_map { |size| @floors[@at].combination(size).to_a }

    # Create a list of possible future states.
    possible_changes = possible_floors.product(possible_loads)

    # If you're moving pairs, it doesn't matter which pair.
    # So if there's a pair in the move, remove all the other pairs.
    pairs = possible_changes.select { |change|
      floor = change[0]
      items = change[1]
      change if items.length == 2 && items.map { |item| item[0,2] }.uniq.length == 1
    }
    
    if pairs.length > 1                  # If there's more than one pair...
      pairs.sort! {|a,b| b[0] <=> a[0]}  # ... sort pairs per floor (so we'll keep the move upwards)
      pairs.shift                        # ... remove the first one 
      pairs.each do |pair|               # ... and remove all the others from possible_changes.
        possible_changes.delete(pair)
      end
    end

    # Make new moves (states) from changes.
    possible_factories = possible_changes.map do |new_floor, items|
      move = self.duplicate  # Duplicate current factory state.
      
      items.each { |item| move.floors[move.at] -= [item] }  # Remove the items from one floor.
      move.at = new_floor
      items.each { |item| move.floors[move.at] += [item] }  # ... and add it to the other.
      
      # Set distance on this move.
      move.distance!
      # Increase the cost, just counting the additional one step.
      move.cost += 1

      move
    end
    possible_factories
  end

  def valid_moves
    self.possible_moves.select { | move| move.valid?  }
  end

  def to_s
    # Create a list of all columns (one object per column).
    columns = []
    @floors.each { |nr, contents|
      columns += contents
    }

    # Print header line.
    string = "====" * (columns.length + 1)

    # Print factory signature.
    puts "hash:" + "E" + @at.to_s + @floors.map { |f,i| "F" + f.to_s + i.sort.join }.join

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
path = Array.new     # A list of factory states, representing actual moves.
queue = Array.new    # A list of moves possibly to be made.
visited = Array.new  # A list of states already considered.

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

factory.at = 1     # The elevator starts at the first floor.
factory.cost = 0   # It was cheap to get here.
factory.goal = 4   # This is where all things need to go to.
factory.distance!  # Compute distance for current state.

# queue = [ [factory, [factory]] ]  # Queue starts with starting position.
queue = [ factory ]  # Queue starts with starting position.
current_state = nil

while !queue.empty?
  puts "queue.length: %d" % queue.length

  # Sort queue on current cost plus remaining cost (estimate).
  queue.sort! { |a, b| a.cost + a.distance <=> b.cost + b.distance }

  # current_state, path = queue.shift  # Get first item from queue.
  current_state = queue.shift  # Get first item from queue.

  # puts current_state

  # Remember current_state as visited.
  visited << current_state
  
  # Test is current state meets goal.
  if current_state.goal_reached?
    puts current_state
    puts "goal reached!"
    break
  end

  # Create all possible states.
  possible_states = current_state.possible_moves

  # Select all valid moves.
  valid_states = possible_states.select { | move| move.valid?  }

  # Select only new ones.
  valid_new_states = valid_states.reject { |f|
    queue.include?(f) || visited.include?(f)
  }

  # Add all these moves to the queue.
  valid_new_states.each do |f|
    queue.push(f)
  end
end

puts "visited.length: %d" % visited.length

# if path.last.goal_reached?
if current_state.goal_reached?
  path.each_with_index do |f, index|
    puts "step %d:" % index
    puts f
  end
else
  puts "no solution"
end
