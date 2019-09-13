# ground = Hash.new  # (Sparse) Hash to store the ground data, position as key.
# Storing ground types. :sand and :spring aren't necessary,
# :bottom created for better testing.
# :frontier to manage frontier positions.
# ground_type = %i(clay water_flow water_rest bottom sand spring) 

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

# TODO Ambiguous: drop just one area of water, multiple, or continuous until end?
def drop_water(ground)
  puts "---\ndrop_water(ground)"

  # Move frontiers down, if that's allowed.
  puts "\n  move frontiers down"
  frontiers = frontiers(ground)
  frontiers.each do |position|
    until ground[ [position[0], position[1] + 1] ]  # Until we hit something...
      ground[position] = :water_flow
      position = [position[0], position[1] + 1]
      ground[position] = :frontier
    end

    # If the water bottoms out, we're done.
    if ground[position] == :bottom
      return ground
    end
  end

  puts string(ground)

  # So far, so good.

  # Put :water_rest to left or right of frontier if both bounded by clay.
  # puts "\n  put water to left or right"
  # TODO Perhaps this is only necessary later, converting :water_flow into :water_rest.

  # Put :water_flow to left and right of frontier if not bounded by clay; move frontier(s).
  puts "\n  put water to left or right"
  frontiers = frontiers(ground)
  frontiers.each do |position|
    # Put :water_flow on current position.
    ground[position] = :water_flow

    original_position = position  # Temporarily store original position.
    # Continue to put :water_flow to the left, and move frontier.



    position = original_position
    # Continue to put :water_flow to the right, and move frontier.
  
  end

  # Return ground to exit this level.
  ground
end


ground = read_scan(gets(nil))
springs = [ [500, 0] ]
drop = 0

# Positions of where water will appear.
springs.each { |s| ground[s] = :frontier }

while true
  drop += 1
  puts "===\ndrop %i" % drop

  ground = drop_water(ground)

  puts string(ground)

end


# Count areas of settled water and where water flowed.
puts ground.count { |p| ground[p] == :water_rest || ground[p] == :water_flow }