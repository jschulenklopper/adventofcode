class Diagram < Hash
  
  attr_reader :width, :height, :start

  def initialize
    @cells = Hash.new  # FIXME This could be self?
    @height = 0
    @width = 0
    @start = nil
  end

  def store(x,y,value)
    cell_id = "%s,%s" % [x,y]
    @height = y+1 if y > @height
    @width = x+1 if x > @width
    @cells[cell_id] = value

    # Store start.
    if y == 0 && value == "|"
      @start = [x,y]
    end
  end

  def get(x,y)
    cell_id = "%s,%s" % [x,y]
    @cells[cell_id]
  end

end

tubes = Diagram.new

# First, read all the input lines, and store the tubes.
lines = readlines
lines.each_with_index do |line, row|
  line.chars.each_with_index do |c, col|
    if c.match(/[|\-+A-Z]/)
      tubes.store(col,row,c)
    end
  end
end

# Then, construct the segments (or: path) by following the tubes.
current = tubes.start
collected = ""
direction = [0,1] # Vector pointing to current direction: down.
steps = 0

while true
  # Navigate to next cell
  current[0] = current[0] + direction[0]
  current[1] = current[1] + direction[1]  # FIXME Can this be nicer?

  steps += 1

  c = tubes.get(current[0], current[1])
  
  break if c == nil

  if c.between?("A", "Z")
    collected << c
  elsif c == "+"
    # direction needs to change.
    # FIXME Can be shorter.
    if direction == [0,1]
      if tubes.get(current[0]+1, current[1])
        direction = [1,0]
      else
        direction = [-1,0]
      end
    elsif direction == [0,-1] 
      if tubes.get(current[0]+1, current[1])
        direction = [1,0]
      else
        direction = [-1,0]
      end
    elsif direction == [1,0]
      if tubes.get(current[0], current[1]+1)
        direction = [0,1]
      else
        direction = [0,-1]
      end
    elsif direction == [-1,0] 
      if tubes.get(current[0], current[1]+1)
        direction = [0,1]
      else
        direction = [0,-1]
      end
    end
  end
end

puts collected
puts steps
