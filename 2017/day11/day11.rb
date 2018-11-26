# Use https://www.redblobgames.com/grids/hexagons/#distances-axial.
def distance(position, from)
  ( (position[0] - from[0]).abs +
    (position[0] + position[1] - from[0] - from[1]).abs +
    (position[1] - from[1]).abs) / 2
end

steps = gets.strip.split(",")

position = [0,0]
start = [0,0]
max_d = 0

steps.each do |step|
  case step
    # Using https://www.redblobgames.com/grids/hexagons/#coordinates-axial.
    when "n" then position[1] -=1
    when "s" then position[1] += 1
    when "nw" then position[0] -= 1
    when "ne" then position[0] += 1; position[1] -= 1
    when "sw" then position[0] -= 1; position[1] += 1
    when "se" then position[0] += 1
  end

  max_d = [max_d, distance(position, start)].max
end

puts "final distance: %s" % distance(position, start)
puts "maximum distance: %s" % max_d