# Get depth and target. Just assume correct input format, and go.
depth = gets.split(" ")[1].to_i
target = gets.split(" ")[1].split(",").map(&:to_i)
mouth = [0,0]

Region = Struct.new(:type, :level, :index)

cave = Hash.new  { |hash, key| hash[key] = Region.new(nil, nil, nil) }

def type_for_level(level)
  # If the erosion level modulo 3 is 0, the region's type is rocky.
  case level % 3
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
  # A region's erosion level is its geologic index plus the cave
  # system's depth, all modulo 20183.
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

def compute_risk(cave, from, to)
  cave.map do |location, region|
    if (from[0] .. to[0]).include?(location[0]) &&
       (from[1] .. to[1]).include?(location[1])
       then case cave[ location ].type
        when :rocky then 0
        when :wet then 1
        when :narrow then 2
       end
    end
  end.compact.sum
end

margin = 1

# Compute type for target... and by recursion all other required regions.
compute_type(cave, [target[0]+margin,target[1]+margin], target, depth)

# Compute risk level.
puts compute_risk(cave, mouth, target)