Bot = Struct.new(:x, :y, :z, :r)
bots = []

while line = gets
  x, y, z, r = line.match(/(\-?\d+),(\-?\d+),(\-?\d+).*=(\d+)/).captures.map(&:to_i)

  bots << Bot.new(x, y, z, r)
end

def bots_in_range(position, bots)
  bots.select { |bot| distance(position, bot) <= bot.r }
end

def nr_bots_in_range(position, bots)
  bots_in_range(position, bots).count
end

def bots_not_in_range(position, bots)
  bots.select { |bot| distance(position, bot) > bot.r }
end

def nr_bots_not_in_range(position, bots)
  bots_not_in_range(position, bots).count
end

def total_distance(position, bots)
  bots.map { |bot| distance(position, bot) }.sum
end

def distance(position, bot)
  (position[0] - bot.x).abs + (position[1] - bot.y).abs + (position[2] - bot.z).abs
end

# Compute center of cloud of bots.
lowest_x, highest_x = bots.map { |b| b.x }.min, bots.map { |b| b.x }.max
center_x = (highest_x + lowest_x) / 2
lowest_y, highest_y = bots.map { |b| b.y }.min, bots.map { |b| b.y }.max
center_y = (highest_y + lowest_y) / 2
lowest_z, highest_z = bots.map { |b| b.z }.min, bots.map { |b| b.z }.max
center_z = (highest_z + lowest_z) / 2

# Take center as 'random' position to start with.
position = [center_x, center_y, center_z]

position = [1310718, 5159414, 3781167]

# Add distances to bots in range and not in range.
position[3] = total_distance(position, bots_in_range(position, bots))
position[4] = total_distance(position, bots_not_in_range(position, bots))
# Add number of bots in range
position[5] = nr_bots_in_range(position, bots)

puts "position: %s" % position.to_s

# Try simulated annealing.
max_steps = 10000      # Max number of steps.
step_size = 10  # TOEXPERIMENT Start with 10000.

(0 ... max_steps).each do |i|
  in_range = position[5]

  # Pick eight neighbors, step_size away.
  new_x = position[0] + step_size * (Random.rand - 0.5 > 0 ? 1 : -1)
  new_y = position[1] + step_size * (Random.rand - 0.5 > 0 ? 1 : -1)
  new_z = position[2] + step_size * (Random.rand - 0.5 > 0 ? 1 : -1)

  new_position = [new_x, new_y, new_z]
  new_position[3] = nil # total_distance(new_position, bots_in_range(new_position, bots))
  new_position[4] = nil # total_distance(new_position, bots_not_in_range(new_position, bots))
  new_position[5] = nr_bots_in_range(new_position, bots)
  puts "new position: %s" % new_position.to_s

  new_in_range = new_position[5]

  # If P( E(s), E(snew), T) ≥ random(0, 1):
  if new_in_range > in_range # t_new_position < t_position
    # If better, then accept it.
    position = new_position
  end

end
# Output: the final state s
puts position[0] + position[1] + position[2]

# Many coordinates are in range of some of the nanobots in this formation. However, only the coordinate 12,12,12 is in range of the most nanobots: it is in range of the first five, but is not in range of the nanobot at 10,10,10. (All other coordinates are in range of fewer than five nanobots.) This coordinate's distance from 0,0,0 is 36.

# Find the coordinates that are in range of the largest number of nanobots. What is the shortest manhattan distance between any of those points and 0,0,0?