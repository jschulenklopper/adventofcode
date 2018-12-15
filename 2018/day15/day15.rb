Unit = Struct.new(:type, :square, :ap, :hp)
class Unit
  def to_s
    t = (type == :elf) ? "E" : "G"
    "%s: %s (%i)" % [t, square.to_s, hp]
  end

  def char
    (type == :elf) ? "E" : "G"
  end

  def <=>(other)
    self.square <=> other.square
  end
end
START_AP = 3
START_HP = 200

Square = Struct.new(:x, :y)
class Square
  def to_s
    "[%i,%i]" % [self.x, self.y]
  end

  def char
    "."
  end

  def <=>(other)
    comp = (self.x <=> other.x)
    (!comp.zero?) ? comp : self.y <=> other.y
  end
end

class Maze < Array  # A maze is just a list of (open) squares.
  attr_accessor :squares, :units

  def initialize
    @squares = Array.new
    @units = Array.new
  end

  def to_s
    min_x, max_x = [self.squares.map {|s| s.x}.min, self.squares.map {|s| s.x}.max]
    min_y, max_y = [self.squares.map {|s| s.y}.min, self.squares.map {|s| s.y}.max]

    lines = ""
    (min_y .. max_y).each do |y|
      (min_x .. max_x).each do |x|
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

maze = Maze.new  # An array of squares.

# Parse input and build map and armies.
y = 0
while line = gets
  break if line.strip.empty?

  x = 0
  line.strip.chars.each do |c|
    case c
    when " "
      break   # Break parsing line after space.
    when "#"  # For now, don't store walls.
    when "G"
      maze.squares << square = Square.new(x,y)
      maze.units << Unit.new(:goblin, square, 3, 200)
    when "E"
      maze.squares << square = Square.new(x,y)
      maze.units << Unit.new(:elf, square, 3, 200)
    when "."
      maze.squares << Square.new(x,y)
    end
    x += 1
  end
  y += 1
end

puts maze.to_s