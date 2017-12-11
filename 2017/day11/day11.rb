# Use https://www.redblobgames.com/grids/hexagons/#distances-axial.
def distance(position, start)
  ( (position[0] - start[0]).abs +
    (position[0] + position[1] - start[0] - start[1]).abs +
    (position[1] - start[1]).abs) / 2
end

steps = gets.strip.split(",")

position = [0,0]
start = [0,0]
max = 0

steps.each { |step|
  case step
    # Using https://www.redblobgames.com/grids/hexagons/#coordinates-axial.
    when "n" then position = [position[0], position[1]-1]
    when "s" then position = [position[0], position[1]+1]
    when "nw" then position = [position[0]-1, position[1]]
    when "ne" then position = [position[0]+1, position[1]-1]
    when "sw" then position = [position[0]-1, position[1]+1]
    when "se" then position = [position[0]+1, position[1]]
  end

  max = [max, distance(position, start)].max
}

puts "final distance: %s" % distance(position, start)
puts "maximum distance: %s" % max
