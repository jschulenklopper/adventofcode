class Grid < Hash
  def set(x,y,value)
    if value == "#" || value == true
      self[[x,y]] = true
    else
      self[[x,y]] = false
    end
  end

  def get(x,y)
    self[[x,y]]
  end

  def on?(x,y)
    self[[x,y]]
  end

  def off?(x,y)
    !self[[x,y]]
  end

  def fix_corners(width,height)
    set(0,0,"#")
    set(0,height-1,"#")
    set(width-1,0,"#")
    set(width-1,height-1,"#")
  end

  def step(width, height)
    new = self.clone
    # In a cloned version, compute the next image
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        if self.on?(x,y) and not [2,3].include?(self.number_of_neighbors_on(x,y))
          new.set(x,y,".")
        end
        if self.off?(x,y) and self.number_of_neighbors_on(x,y) == 3
          new.set(x,y,"#")
        end
      end
    end
    # Set the image according to the values in the clone.
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        if new.get(x,y)
          self.set(x,y,"#")
        else
          self.set(x,y,".")
        end
      end
    end
  end

  # Return number of neighboring lights that are on.
  def number_of_neighbors_on(x,y)
    count = 0
    [-1,0,1].each do |i|
      [-1,0,1].each do |j|
        if self.get(x-i,y-j) && ([i,j] != [0,0])
          count += 1
        end
      end
    end
    count
  end

  # Return number of lights that are on.
  def number_of_lights_on(width, height)
    count = 0
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        count += 1 if self.get(x,y)
      end
    end
    count
  end

  # Returns image of grid.
  def image(width, height)
    string = ""
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        if self.get(x,y)
          string << "#"
        else
          string << "."
        end
      end
      string << "\n"
    end
    string << "\n"
  end
end

grid = Grid.new

x,y = 0,0
while line = gets do
  x = 0
  line.each_char do |light|
    grid.set(x, y, light)
    x += 1
  end
  y += 1
end

width = x-1
height = y

grid.fix_corners(width, height)

100.times do
  grid.step(width, height)
  grid.fix_corners(width, height)
end

puts grid.number_of_lights_on(width, height)