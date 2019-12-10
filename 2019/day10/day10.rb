# Get map.
lines = ARGF.readlines.map(&:strip)

region = Hash.new
dimensions = [0,0]

# Read region.
lines.each.with_index do |line, y|
  line.chars.each.with_index do |position, x|
    region[ [x,y] ] = position
    dimensions = [x,y]
  end
end

def distance(from, to)
  Math.sqrt((from[0] - to[0])**2 + (from[1] - to[1])**2)
end

def direction(from, to)
  Math.atan2(from[1]-to[1], from[0]-to[0])
end

def count_asteroids(map, dimensions, from_position)
  count = 0
  x, y = from_position

  sight_map = Hash.new
  map.select do |pos,item|
    if item == "#" && pos != from_position
      distance = distance(pos, from_position)
      direction = direction(pos, from_position)
      sight_map[pos] = [distance, direction]
    end
  end
  
  sight_map.map { |_,value| value[1] }.uniq.length
end

in_sight = Hash.new

region.each do |pos,item|
  in_sight[ [pos] ] = count_asteroids(region, dimensions, pos) if item == "#"
end

puts in_sight.map { |p,value| value }.max
