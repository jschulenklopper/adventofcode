require 'matrix'

class Matrix
  # Additional method to get the matrix value 'at' the position.
  def tube?(position)
    self[position[0], position[1]] && self[position[0], position[1]] != " "
  end
end

# First, read all the input lines and store the grid in a matrix.
lines = readlines
grid = Matrix.rows(lines.map { |line| line.chomp.chars })

# Set up constants and variables.
Directions = {:N => Vector[-1,0], :S => Vector[1,0],
              :W => Vector[0,-1], :E => Vector[0,1] }
direction = :S  # Vector pointing to current direction: down.
collected = ""
steps = 0

# Find the starting position on first row.
current = Vector[0, grid.row(0).to_a.index("|")]

# Then, construct path by following the lines.
while true
  # Navigate to and get next cell
  current += Directions[direction]
  steps += 1
  c = grid[current[0],current[1]]

  # Apparently, we've reached the end of the path.
  break if c == nil || c == " "

  if c.between?("A", "Z")
    collected << c  # Collect character.
  elsif c == "+"  # Change direction.
    if direction == :E || direction == :W
      south = current + Directions[:S]
      direction = grid.tube?(south) ? :S : :N
    elsif direction == :S || direction == :N
      east = current + Directions[:E]
      direction = grid.tube?(east) ? :E : :W
    end
  end
end

puts collected
puts steps
