# ground = Hash.new  # (Sparse) Hash to store the ground data, position as key.
# Storing ground types. :sand and :spring aren't necessary,
# :bottom created for better testing.
# :frontier to manage frontier positions.
# ground_type = %i(clay water_flow water_rest bottom sand spring frontier) 

def string(ground)
  min_x, max_x = [ground.keys.map { |pos| pos[0] }.min , ground.keys.map { |pos| pos[0] }.max]
  min_y, max_y = [ground.keys.map { |pos| pos[1] }.min , ground.keys.map { |pos| pos[1] }.max]

  lines = []
  (min_y .. max_y).each do |y|
    line = "%4i  " % y
    (min_x .. max_x).each do |x|
      line += case ground[ [x,y] ]
      when :clay then "#"
      when :frontier then "!"
      when :water_flow then "|"
      when :water_rest then "~"
      when :bottom then "_"
      else "."
      end
    end
    lines << line
  end
  lines.join("\n")
end

def read_scan(input)
  ground = Hash.new
  # Read scanned data and build ground structure.
  lines = input.split("\n")
  while line = lines.shift do
    static_coor, value, range_coor, range = line.match(/^(x|y)=(\d+).*(y|x)=([\d\.]+)/).captures
    Range.new(*range.split("..").map(&:to_i)).each do |r|
      if static_coor == "x"  # Range is on Y values.
        ground[ [value.to_i, r] ] = :clay
      else  # Range is on X values.
        ground[ [r, value.to_i] ] = :clay
      end
    end
  end

  # Add bottom to ground.
  min_x, max_x = [ground.keys.map { |pos| pos[0] }.min , ground.keys.map { |pos| pos[0] }.max]
  min_y, max_y = [ground.keys.map { |pos| pos[1] }.min , ground.keys.map { |pos| pos[1] }.max]
  (min_x-1 .. max_x+1).each { |x| ground[ [x, max_y+1] ] = :bottom }

  ground
end

# Monkey-patch `Object` with convenience method: testing whether element is in enumerable.
class Object
  def in?(array)
    return array.include?(self)
  rescue NoMethodError
    raise ArgumentError.new("The parameter passed to #in? must respond to #include?")
  end
end

def frontiers(ground)
  puts "frontiers() at: " + ground.select { |k,v| v == :frontier }.keys.to_s
  ground.select { |k,v| v == :frontier }.keys
end

# Advance every (water drop) frontier one step.
def drop_water(ground)
  puts "---\ndrop_water(ground)"

  # Gather all active frontiers.
  puts "\n  gather frontiers"
  p frontiers = frontiers(ground)

  puts "\n  move frontiers one step"
  # Advance all frontiers one step.
  frontiers.each do |position|
    # If frontier reaches the bottom, we're done.
    # Turn all frontiers into flowing water and break.
    if ground[position] == :bottom
      ground.each { |k,v| v = :water_flow if v == :frontier }
      return ground
    end

    # If area below frontier is empty, move frontier one step down
    # and mark the ground as wet.
    below_position = [ position[0], position[1] + 1 ]
    if ground[below_position] == nil
      ground[position] = :water_flow
      ground[below_position] = :frontier
      break  # TODO OR use case statement, or multiple if/elsif/else.
    end

    # If area below frontier is clay or water, then make ground wet,
    # and create frontiers left and right if possible.
    if ground[below_position] == :clay || ground[below_position] == :water_flow
      ground[position] = :water_flow

      left_position = [ position[0] - 1, position[1] ]
      if ground[left_position] == nil
        ground[left_position] = :frontier
      end

      right_position = [ position[0] + 1, position[1] ]
      if ground[right_position] == nil
        ground[right_position] = :frontier
      end

      break
    end

  end

  # Return ground to exit this level.
  ground
end

ground = read_scan(gets(nil))
springs = [ [500, 0] ]
drop = 0

# Positions of where water will appear.
springs.each { |s| ground[s] = :frontier }

# Show starting position of ground.
puts "==="
puts string(ground)

while true
  drop += 1
  puts "===\ndrop %i" % drop

  # Make a new drop to find it's way.
  ground = drop_water(ground)
  puts string(ground)

  # Break in case there aren't any frontiers left.
  break if frontiers(ground).empty?
end


# Count areas of settled water and where water flowed.
puts ground.count { |p| ground[p] == :water_rest || ground[p] == :water_flow }
