# Read route and strip newline.
route = gets.strip[1..-2].chars

Room = Struct.new(:north, :east, :south, :west, :d)

def string(facility)
  # Find min/maxes.
  positions = facility.map { |k, _| x, y = k }
  min_x, max_x = positions.map { |x,y| x }.min, positions.map { |x,y| x }.max
  min_y, max_y = positions.map { |x,y| y }.min, positions.map { |x,y| y }.max

  min_x, max_x, min_y, max_y = [min_x, max_x, min_y, max_y].map { |v| (v == nil) ? 0 : v }
  
  # Generate grid.
  line = ""
  (min_y .. max_y).each do |y|
    (min_x .. max_x).each do |x|
      line += "#"
      if facility[ [x,y] ] && facility[ [x,y] ].north then line += "." else line += "#" end
    end
    line += "#\n"
    (min_x .. max_x).each do |x|
      if facility[ [x,y] ] && facility[ [x,y] ].west then line += "." else line += "#" end
      if [x,y] == [0,0]
        then line += "X"
      elsif facility[ [x,y] ]
        then line += "."
        # then line += facility[ [x,y] ].d.to_s[-1] 
      end
    end
    line += "#\n"
  end
  (min_x .. max_x).each do |x| line += "##" end
  line += "#\n"
end

# Read route from position, recursively. Return updated graph.
def read_route(route, start, facility, level)
  # puts "%sread_route(%s, %s, facility)" % ["  " * level, route.join, start.to_s]
  current = start.dup

  # Create facility from this part of the route.
  while direction = route.shift
    # Get (or create) room for this position.
    x, y = [current[0], current[1]]
    room = facility[ [x, y] ]

    # Create rooms next door if direction is part of %w(N E S W).
    if direction == "N"
      room.north = facility[ [x,y-1] ]
      facility[ [x,y-1] ].south = room
      current[0], current[1] = [x, y-1]
    elsif direction == "E"
      room.east = facility[ [x+1,y] ]
      facility[ [x+1,y] ].west = room
      current[0], current[1] = [x+1, y]
    elsif direction == "S"
      room.south = facility[ [x,y+1] ]
      facility[ [x,y+1] ].north = room
      current[0], current[1] = [x, y+1]
    elsif direction == "W"
      room.west = facility[ [x-1,y] ]
      facility[ [x-1,y] ].east = room
      current[0], current[1] = [x-1, y]
    elsif direction == "|"
      # Create parallel facility from starting position.
      return facility = read_route(route, start, facility, level)
    elsif direction == "("
      # Create subfacility from starting position.
      facility = read_route(route, current, facility, level+1)
    elsif direction == ")"
      # Return this part of sub to recursive call.
      return facility
      # FIXME I think the bug is here.
    end
  end
  facility
end

def add_distances(facility, from)
  queue = [ [from, 0] ]

  while entry = queue.shift
    position, distance = entry
    room = facility[position]
    if room.d == nil       # Room hasn't been visited yet.
      room.d = distance  # ... so store lower distance
      # ... and add neighbor rooms to the queue.
      queue << [ [position[0], position[1]-1], distance+1] if room.north
      queue << [ [position[0]+1, position[1]], distance+1] if room.east
      queue << [ [position[0], position[1]+1], distance+1] if room.south
      queue << [ [position[0]-1, position[1]], distance+1] if room.west
    end
  end
  
  facility
end

facility = Hash.new { |facility, position| facility[position] = Room.new(nil, nil, nil, nil, nil) }
start = [0,0]

# Create (map of) facility.
facility = read_route(route, start, facility, 0)

# Add the distance to start to all the rooms in the facility.
facility = add_distances(facility, start)

puts facility.select { |k, v| v.d >= 1000 }.length