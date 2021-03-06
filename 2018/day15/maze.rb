class Maze < Array  # A maze is just a list of (open) squares.
  attr_accessor :squares, :units

  def initialize(input)
    @squares = Array.new
    @units = Array.new

    # Parse input and build map and armies.
    y = 0
    input.split("\n").each do |line|
      break if line.strip.empty?

      x = 0
      line.strip.chars.each do |c|
        case c
        when " "
          break   # Break parsing line after space.
        when "#"  # For now, don't store walls.
        when "G"
          @squares << square = Square.new(x,y)
          @units << Unit.new(:goblin, square, 3, 200, true)
        when "E"
          @squares << square = Square.new(x,y)
          @units << Unit.new(:elf, square, 3, 200, true)
        when "."
          @squares << Square.new(x,y)
        end
        x += 1
      end
      y += 1
    end
  end

  def units_on_square(square)
    units.select { |u| u.square == square }
  end

  def units_alive
    @units.select { |u| u.alive }.sort 
  end

  def opponents_alive(unit)
    @units.select { |o| o.alive && o.type != unit.type }.sort
  end

  def opponents_in_range(unit)
    opponents_alive(unit).select { |o| o.distance(unit) == 1}
  end

  def squares_in_range(opponents)
    squares.select { |s|
      square_free = units_on_square(s).length == 0
      units_close = opponents.select { |o| s.distance(o.square) == 1 }.length > 0

      square_free && units_close
    }.sort
  end

  def to_s
    min_x, max_x = [self.squares.map {|s| s.x}.min, self.squares.map {|s| s.x}.max]
    min_y, max_y = [self.squares.map {|s| s.y}.min, self.squares.map {|s| s.y}.max]

    lines = ""
    (min_y-1 .. max_y+1).each do |y|
      (min_x-1 .. max_x+1).each do |x|
        if unit = units.find { |u| u.square.x == x && u.square.y == y }
          lines += unit.char
        elsif squares.select { |s| s.x == x && s.y == y }.length > 0
          lines += "."
        else
          lines += "#"
        end
      end #
      lines += "\n"
    end
    lines
  end
end

