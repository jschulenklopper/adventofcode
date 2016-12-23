class Node
  attr_accessor :x, :y, :name, :size, :used, :avail

  def initialize(x, y, name, size, used, avail)
    @x = x
    @y = y
    @name = name
    @size = size
    @used = used
    @avail = avail
  end

  def to_s
    "[%s,%s]" % [@x,@y]
  end
end

class Grid < Hash
  attr_reader :max_x, :max_y, :min_size

  def initialize
    @max_x = 0
    @max_y = 0
    @min_size = nil
  end

  def []=(position, node)
    @max_x = position[0] if position[0] > @max_x
    @max_y = position[1] if position[1] > @max_y
    @min_size = node.size if @min_size == nil
    @min_size = node.size if node.size < @min_size
    super
  end

  def to_s
    string = ""
    (0..@max_y).to_a.each do |y|
      row = ""
      (0..@max_x).to_a.each do |x|
        if self[[x,y]].used == 0
          row << " _ "
        elsif x == @max_x && y == 0
          row << " G "
        elsif x == 0 && y == 0
          row << " ! "
        elsif self[[x,y]].used > @min_size
          row << " x "
        else
          row << " . "       
        end
      end
      row << "\n"
      string << row
    end
    string
  end

  def can_data_move?(from, to)
    if from != to && from.used != 0 && from.used <= from.avail
      true
    else
      false
    end
  end

  def move_data!(from, to)
    to.used += from.used
    to.avail -= from.used
  end
end

grid = Grid.new
# Read all the node data
while line = gets
  line.match(/\/dev\/grid\/(?<name>node-x(?<x>\d+)-y(?<y>\d+))\s+(?<size>\d+)T\s+(?<used>\d+)T\s+(?<avail>\d+)T\s+(?<use>\d+)%/) do |match|
    x, y = match[:x].to_i, match[:y].to_i
    node = Node.new(match[:x].to_i,
                    match[:y].to_i,
                    match[:name],
                    match[:size].to_i,
                    match[:used].to_i,
                    match[:avail].to_i)
  grid[[x,y]] = node
  end
end

# Print the grid.
puts grid

# Manually count the number of moves for the 'empty' node to near the goal data,
# between the goal data and the [0,0] node.
# Then 'circle' around the empty node around the goal data, moving it one step
# closer in five moves. Stop counting if goal data is shoved to [0,0].

