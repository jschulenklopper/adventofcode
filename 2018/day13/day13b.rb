require 'matrix'

# Create a Cart class to hold cart's data.
Cart = Struct.new(:id, :position, :direction, :nr_turns, :crashed)

BEND_CHARS = %w( / \\ )
STRAIGHT_CHARS = %w( | - )
INTERSECTION_CHARS = %w( + )
TRACK_CHARS = BEND_CHARS + STRAIGHT_CHARS + INTERSECTION_CHARS
CART_CHARS = %w( > < ^ v )
DIRECTIONS = { "v" => [0,1], "^" => [0,-1], ">" => [1,0], "<" => [-1,0] } 
# DIRECTIONS_TOO = { :down => [0,1], :up => [0,-1], :right => [1,0], :left => [-1,0] } 
NEXT_DIRECTION = { ["/",[0,1]] => [-1,0],  # TODO Can this be done nicer?
                   ["/",[0,-1]] => [1,0],
                   ["/",[1,0]] => [0,-1],
                   ["/",[-1,0]] => [0,1],
                   ["\\",[0,1]] => [1,0],
                   ["\\",[0,-1]] => [-1,0],
                   ["\\",[1,0]] => [0,1],
                   ["\\",[-1,0]] => [0,-1] }

# Build matrices for turns. Can be applied to direction:
#   direction * turn = new direction
TURNS = { :left => Matrix[ [0, -1], [1, 0] ],
           :straight => Matrix[ [1, 0], [0, 1] ],
           :right => Matrix[ [0, 1], [-1, 0] ] }
# Carts take turns in this order. Use nr_turns % 3 to figure out next turn.
TURN_ORDER = [:left, :straight, :right]

tracks = Hash.new  # [x,y] => track ( /, |, \, -, or + )
carts = Array.new  # of Cart structs

lines = gets(nil).split("\n")
lines.each.with_index { |line, y|
  line.chars.each.with_index { |c, x|
    tracks[ [x,y] ] = c if TRACK_CHARS.include?(c)
    carts << Cart.new(carts.length, [x,y], DIRECTIONS[c], 0, false) if CART_CHARS.include?(c)  # id, position, direction, nr_of_turns
    # Add missing track if it is covered with cart.
    case c
      when ">" then tracks[ [x,y] ] = "-"
      when "<" then tracks[ [x,y] ] = "-"
      when "^" then tracks[ [x,y] ] = "|"
      when "v" then tracks[ [x,y] ] = "|"
    end
  }
}

def print(tracks, carts)
  min_x, max_x = [tracks.keys.map(&:first).min, tracks.keys.map(&:first).max]
  min_y, max_y = [tracks.keys.map(&:last).min, tracks.keys.map(&:last).max]

  (min_y .. max_y).each do |y|
    line = ""
    (min_x .. max_x).each do |x|
      if i = carts.find_index { |c| c.position == [x,y] }

        line += DIRECTIONS.key( carts[i].direction )
      elsif tracks.key?([x,y])
        line += tracks[ [x,y] ]
      else
        line += " "
      end
    end
    puts line
  end
end

# Move one step in current direction.
def ride(cart, tracks)
  cart.position = [cart.position, cart.direction].transpose.map(&:sum)

  # If it is a bend, change direction (for next move).
  segment = tracks[cart.position]
  if BEND_CHARS.include?(segment)
    cart.direction = NEXT_DIRECTION[ [segment, cart.direction] ]
  end

  # If it is a intersection, change direction (for next move).
  if INTERSECTION_CHARS.include?(segment)
    turn = TURN_ORDER[cart.nr_turns % TURN_ORDER.length]
    cart.direction = (Matrix[cart.direction] * TURNS[turn]).to_a[0]

    # Update turn counter.
    cart.nr_turns += 1
  end

  # Finally, return the updated cart.
  cart
end

# Move all carts one tick.
def move(carts, tracks)
  # Order carts in proper order.
  carts.sort! { |one, two| one.position <=> two.position }

  # Process all carts...
  carts.each do |cart|
    # ... by moving each seperate cart.
    cart = ride(cart, tracks)

    # If there's a collision, mark all the carts at car.position.
    crash_site = cart.position
    if carts.select { |c| c.position == crash_site }.length > 1
      carts.each { |c| c.crashed = true if c.position == crash_site }
    end
  end

  # Remove cars marked as crashed.
  carts.delete_if { |c| c.crashed }

  # Return the new list of carts.
  carts
end

tick = 0
while true
  carts = move(carts, tracks)

  if carts.length == 1
    puts carts.first.position.join(",")
    exit
  end

  tick += 1
end