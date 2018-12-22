# Get depth and target. Just assume correct input format, and go.
depth = gets.split(" ")[1].to_i
target = gets.split(" ")[1].split(",").map(&:to_i)
mouth = [0,0]

Region = Struct.new(:type, :level, :index)

cave = Hash.new  { |hash, key| hash[key] = Region.new(nil, nil, nil) }

def type_for_level(level)
  case level % 3
    # If the erosion level modulo 3 is 0, the region's type is rocky.
    when 0 then :rocky
    # If the erosion level modulo 3 is 1, the region's type is wet.
    when 1 then :wet
    # If the erosion level modulo 3 is 2, the region's type is narrow.
    when 2 then :narrow
  end
end

def compute_type(cave, location, target, depth)
  level = compute_level(cave, location, target, depth) % 3
  type = type_for_level(level)

  cave[ location ].type = type
end

def compute_level(cave, location, target, depth)
  # A region level is its index plus the cave system's depth, all modulo 20183.
  level = (compute_index(cave, location, target, depth) + depth) % 20183

  cave[ location ].level = level
end

def compute_index(cave, location, target, depth)
  return 0 if location[0] < 0 || location[1] < 0

  # Compute or retrieve levels of location left and above current location.
  if location[0] > 0 || location[1] > 0
    left = [ location[0]-1, location[1] ]
    compute_type(cave, left, target, depth) unless cave.has_key?(left)
    level_left = cave[ left ].level

    above = [ location[0], location[1]-1 ]
    compute_type(cave, above, target, depth) unless cave.has_key?(above)
    level_above = cave[ above ].level
  end

  index = nil

  if location == [0,0]
    # The region at 0,0 (the mouth of the cave) has a geologic index of 0.
    index = 0
  elsif location == target
  # The region at the coordinates of the target has a geologic index of 0.
    index = 0
  elsif location[1] == 0
  # If the region's Y coordinate is 0, the geologic index is its X coordinate times 16807.
    index = location[0] * 16807
  elsif location[0] == 0
    # If the region's X coordinate is 0, the geologic index is its Y coordinate times 48271.
    index = location[1] * 48271
  else
    # Otherwise, the region's geologic index is the result of multiplying
    # the erosion levels of the regions at X-1,Y and X,Y-1.
    index = level_left * level_above
  end

  cave[ location ].index = index
end

def print(cave, mouth, target, area)
  start_x, start_y = mouth
  area_x, area_y = area

  line = ""
  (start_y .. area_y).each do |y|
    (start_x .. area_x).each do |x|
      region = cave[ [x,y] ]
      char = ""
      if [x,y] == mouth then char = "M"
      elsif [x,y] == target then char = "T"
      elsif region.type == :rocky then char = "."
      elsif region.type == :wet then char = "="
      elsif region.type == :narrow then char = "|"
      else char = " "
      end
      line += char
    end
    line += "\n"
  end
  line
end

def allowed_tools(region)
  case region.type
  when :rocky
    # In rocky regions, you can use the climbing gear or the torch.
    [:climbing, :torch]
  when :wet
    # In wet regions, you can use the climbing gear or neither tool.
    [:climbing, :neither]
  when :narrow
    # In narrow regions, you can use the torch or neither tool.
    [:neither, :torch]
  end
end

def switch_time(from_tool, to_tool)
  (from_tool == to_tool) ? 0 : 7
end

def target_reached?(position, target, tool)
  (position == target && tool == :torch) ? true : false
end

def new_positions(position)
  new_positions = [-1, +1].map { |d| [ position[0] + d, position[1] ] } +
                  [-1, +1].map { |d| [ position[0], position[1] + d ] }
  new_positions.reject { |p| p[0] < 0 || p[1] < 0 }
end

def estimate(from, to)
  (from[0] - to[0]).abs + (from[1] - to[1]).abs
end

def find_fastest_path(cave, from, target, tool)
  # Maintain a queue with positions, tools at that position, and distance so far.
  queue = [ [from, tool, 0, 100000] ]
  visited = []  # Just list of positions.

  until queue.empty?
    # Get first from distance-sorted queue and store as visited.
    queue.sort! { |a,b| (a[3] <=> b[3]) }

    # Get tuple for position, tool and distance so far from queue.
    position, current_tool, distance, estimate = queue.shift

    visited << position

    puts "queue: %s, visited: %i" % [queue.length, visited.length]

    # Check if target is reached with correct tool.
    if target_reached?(position, target, current_tool)
      return [position, current_tool, distance] # \o/
    end

    # Generate all options for moving or changing tools
    new_positions = new_positions(position)
    really_new_positions = new_positions.reject { |p| visited.include?(p) } # Reject earlier visited.
    allowed_positions = really_new_positions.select { |p| allowed_tools( cave[ p ]).include?(current_tool) }

    allowed_tools = allowed_tools(cave[ position ]) - [current_tool]

    # New entries for queue are new positions (+1 minute)
    # or same position with other tool (+7 minutes).
    allowed_positions.each do |new_position|
      new_estimate = estimate(new_position, target)
      # unless queue.include?( [new_position, current_tool, distance + 1])
      # unless queue.map { |q| [q[0], q[1]] }.include?( [new_position, current_tool])
      unless queue.select { |q| [q[0], q[1]] if q[3] < distance + 1 + new_estimate }.include?( [new_position, current_tool])
        queue << [new_position, current_tool, distance + 1, distance + 1 + new_estimate]
      end
    end
    allowed_tools.each do |new_tool|
      # unless queue.include?( [position, new_tool, distance + 7])
      new_estimate = estimate(position, target)
      # unless queue.include?( [position, new_tool, distance + 7])
      # unless queue.map { |q| [q[0], q[1]] }.include?( [position, new_tool])
      unless queue.select { |q| [q[0], q[1]] if q[3] < distance + 7 + new_estimate }.include?( [position, new_tool])
        queue << [position, new_tool, distance + 7, distance + 7 + new_estimate]
      end
    end
  end

  # No path found.
  return nil

end

margin = 500

# Compute type for target... and by recursion all other required regions.
compute_type(cave, [target[0]+margin,target[1]+margin], target, depth)

# You start at 0,0 (the mouth of the cave) with the torch equipped
# and must reach the target coordinates as quickly as possible.
if path = find_fastest_path(cave, mouth, target, :torch)
  puts duration = path.last
end