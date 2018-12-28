# Get depth and target. Just assume correct input format, and go.
depth = gets.split(" ")[1].to_i
target = gets.split(" ")[1].split(",").map(&:to_i)
mouth = [0,0]

Region = Struct.new(:type, :level, :index, :duration)

cave = Hash.new  { |hash, key| hash[key] = Region.new(nil, nil, nil, Float::INFINITY) }

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

# TODO This can also be computed as required, instead of at the beginning.
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

def allowed_tools(region)
  abort("unknown region encountered") if region == nil
  case region.type
    # In rocky regions, you can use the climbing gear or the torch.
    when :rocky then [:climbing, :torch]
    # In wet regions, you can use the climbing gear or neither tool.
    when :wet then [:climbing, :neither]
    # In narrow regions, you can use the torch or neither tool.
    when :narrow then [:neither, :torch]
  end
end

def is_allowed?(tool, region)
  allowed_tools(region).include?(tool)
end

def target_reached?(position, target, tool)
  (position == target && tool == :torch) ? true : false
end

def new_positions(position)
  # Generate positions above, left, right and under.
  new_pos = [-1, +1].map { |d| [ position[0] + d, position[1] ] } +
            [-1, +1].map { |d| [ position[0], position[1] + d ] }
  # Remove positions too far above or left.
  new_pos.reject! { |p| (p[0] < 0) || (p[1] < 0) }
  new_pos.reject! { |p| (p[0] > 100) || (p[1] > 900) } # DEBUG
  new_pos
end

def estimate(from, to)
  (from[0] - to[0]).abs + (from[1] - to[1]).abs
end

def find_fastest_path(cave, from, target, tool)
  # Maintain a queue with position, tool at that position, and duration so far.
  queue = [ [from, tool, 0] ]
  visited = Hash.new 

  until queue.empty?
    # Get first from duration-sorted queue.
    queue.sort! { |a,b| a[2] <=> b[2] }

    # Get tuple for position, tool and duration so far from queue.
    current_position, current_tool, duration = queue.shift

    # Register current position as visited with duration.
    visited[ [current_position, current_tool] ] = duration

    # If target reached, return position, tool and duration.
    return [current_position, current_tool, duration] if target_reached?(current_position, target, current_tool)

    # Find possible positions from here.
    possible_positions = new_positions(current_position)
    # Reject positions not allowed with current tool, already on queue, or visited before.
    possible_positions.reject! { |p| ! is_allowed?(current_tool, cave[ p ]) || 
                                     queue.select { |q| q[0] == p && q[1] == current_tool && (q[2] <= duration + 1) }.length > 0 ||
                                     visited[ [p, current_tool] ] && (visited[ [p, current_tool] ] < duration + 1) }
                                     visited[ [p, current_tool] ] }
    # Add possible positions to queue.
    possible_positions.each { |p| queue << [p, current_tool, duration + 1] }

    # Find allowed tools here minus the current one.
    allowed_tools = allowed_tools(cave[ current_position ]) - [current_tool]
    # Reject positions+tools that are already on the queue or visited before.
    allowed_tools.reject! { |t| queue.select { |q| q[0] == current_position && q[1] == t && (q[2] <= duration + 7) }.length > 0 ||
                                visited[ [current_position, t] ] && (visited[ [current_position, t] ] < duration + 7) }
                                visited[ [current_position, t] ] }
    # Add allowed tools for current position to queue.
    allowed_tools.each { |t| queue << [current_position, t, duration + 7] }
  end

  # No path found.
  return nil
end

margin = 200  # This margin isn't needed when we're 'lazy loading' types.

# Compute type for target... and by recursion all other required regions.
compute_type(cave, [target[0]+margin,target[1]+margin], target, depth)

# You start at 0,0 (the mouth of the cave) with the torch equipped
# and must reach the target coordinates as quickly as possible.
if last_step = find_fastest_path(cave, mouth, target, :torch)
  puts duration = last_step[2]
end