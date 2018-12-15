START_AP = 3
START_HP = 200

Unit = Struct.new(:type, :square, :ap, :hp, :alive)
Square = Struct.new(:x, :y)

class Unit
  def to_s
    t = (type == :elf) ? "E" : "G"
    "%s: %s (%i)" % [t, square.to_s, hp]
  end

  def char
    (type == :elf) ? "E" : "G"
  end

  def distance(unit)
    square.distance(unit.square)
  end

  def <=>(other)
    square <=> other.square
  end
end

class Square
  def to_s
    "[%i,%i]" % [x, y]
  end

  def char
    "."
  end

  def distance(square)
    (x - square.x).abs + (y - square.y).abs
  end

  def <=>(other)
    comp = (y <=> other.y)
    (!comp.zero?) ? comp : x <=> other.x
  end
end

class Maze < Array  # A maze is just a list of (open) squares.
  attr_accessor :squares, :units

  def initialize
    @squares = Array.new
    @units = Array.new
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

maze = Maze.new

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
      maze.units << Unit.new(:goblin, square, 3, 200, true)
    when "E"
      maze.squares << square = Square.new(x,y)
      maze.units << Unit.new(:elf, square, 3, 200, true)
    when "."
      maze.squares << Square.new(x,y)
    end
    x += 1
  end
  y += 1
end

round = 1
sum_hp = 0

# Take turns until no opponents are alive.
while true
  puts "\n===\nround: %i" % round
  puts maze.to_s

  # Get (sorted) list of all units alive.
  units = maze.units_alive
  # puts units.map { |u| u.to_s }

  # Each unit still alive takes a turn.
  units.each do |unit|
    puts "---\nunit:"
    puts unit.to_s

    # a. Identify targets: opponents alive.
    opponents = maze.opponents_alive(unit)

    puts "opponents:"
    puts opponents.map { |o| o.to_s }

    #   1. If there aren't opponents: this unit's turn ends.
    break if opponents.length == 0

    # b. Find open squares in range of opponents.
    puts "squares in range:"
    squares_in_range = maze.squares_in_range(opponents)
    puts squares_in_range.map { |s| s.to_s }

    #    ... or opponents already in range.
    puts "opponents already in range:"
    opponents_in_range = maze.opponents_in_range(unit)
    puts opponents_in_range.map { |o| o.to_s }

    #    1. There might not be open squares or opponents in range:
    #       end this turn.
    if opponents_in_range.empty? && squares_in_range.empty?
      next
    end

    # c. If there's no opponent in range now: move.
    #    1. Find closest squares in range. Pick first.
    #    2. Find shortest routes. Pick first.
    #    3. Move.
    # d. If there's an opponent in range: attack.
    #    1. Find opponents in range. Pick weakest, or first.
    #    2. Attack.
    #    3. If target's HP 0 or lower, mark as dead.
  end

  round += 1
  break if round > 1  # Replace with exit condition.
end

# puts (round-1) * sum_hp