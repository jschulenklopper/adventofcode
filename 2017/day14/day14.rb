def hash(input, start, skip, lengths)
  lengths.each do |length|
    # Rotate string to start.
    input = input.rotate(start)
    # Input becomes reversed part plus remainder.
    input = input[0, length].reverse + input[length..-1]
    # ... and then rotate it backwards again.
    input = input.rotate(-1 * start)

    # Move start position, increase skip length.
    start = (start + length + skip) % input.length
    skip = (skip + 1)
  end

  # Return output and new start and skip values.
  [input, start, skip]
end

def knothash(string)
  bytes = string.chars.map(&:ord) + [17, 31, 73, 47, 23]
  list = (0...256).to_a

  current = 0
  skip_size = 0
  64.times do
    list, current, skip_size = hash(list, current, skip_size, bytes)
  end
  
  # Compute dense hash from sparse hash that is in list.
  return list.each_slice(16).map { |s| s.reduce(&:^).to_s(16).rjust(2, "0") }.join
end

def neighbors(grid, x, y)
  neighbors = []
  nr_rows = grid.length
  nr_cols = grid.first.length
  neighbors << [y-1,x] if y > 0
  neighbors << [y+1,x] if y < nr_rows - 1
  neighbors << [y,x-1] if x > 0
  neighbors << [y,x+1] if x < nr_cols - 1
  neighbors
end

def color_neighbors(grid, x, y, color)
  neighbors = neighbors(grid, x, y)

  # Color all neighbors the color of the current cell.
  neighbors.each do |cell|
    if grid[cell[0]][cell[1]] == "#"
      grid[cell[0]][cell[1]] = color
      # And color all the neighbors as well.
      color_neighbors(grid, cell[1], cell[0], color)
    end
  end

end

def color(grid)
  color = 0

  grid.each_with_index do |row, y|
    row.each_with_index do | col, x|
      # If cell isn't colored yet, increase color number and assign color to cell.
      if grid[y][x] == "#"
        # Make new color and assign it to the cell.
        color += 1
        grid[y][x] = color
        # Recursively color all the neighbors of this cell.
        color_neighbors(grid, x, y, color)
      end

    end
  end
end

def print(grid)
  puts grid.map { |row| row.join + "\n" }.join
end

grid = []

input  = gets.strip

nr_squares = 0

(0..127).each do |i|
  p line = input + "-" + i.to_s
  p hash = knothash(line)

  bits = "%0128b" % hash.to_i(16)
  grid[i] = bits.chars.map { |c| (c=="1") ? "#" : "." }

  grid[i].join

  nr_squares += bits.count("1")
end

puts nr_squares

print(grid)

color(grid)

puts grid.flatten.reject { |c| c == "." }.uniq.length
