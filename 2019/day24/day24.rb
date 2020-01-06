input = ARGF.readlines.map(&:strip)
SIZE = 5

grid = Hash.new { |hash, key| hash[key] = "." }

# Populate grid.
(0...SIZE).each do |y|
  (0...SIZE).each do |x|
    grid[ [x,y] ] = input[y][x]
  end
end

def count_neighbor_bugs(grid)
  neighbors = Hash.new { |hash,key| hash[key] = 0}

  grid.each do |pos, _|
    x,y = pos
    neighbors[pos] = grid.count { |cell, value|
      dx, dy = cell
      value == "#" && (
        ((dx-x).abs == 1 && dy-y == 0) || 
        ((dy-y).abs == 1 && dx-x == 0)
      )
    }
  end

  neighbors
end

def live_and_let_die(grid, neighbor_count)
  neighbor_count.each do |pos, value|
    if grid[ pos ] == "#"
      grid[ pos ] = "." if not [1].include?(value)
    elsif grid[ pos ] == "."
      grid[ pos ] = "#" if [1,2].include?(value)
    end
  end
  grid
end

def biodiversity(grid)
  # Turn grid into array, ordered by original position (first row, then next row).
  array = grid.keys.sort { |a,b| ((a[1] <=> b[1]) == 0) ? a[0] <=> b[0] : a[1] <=> b[1]}.map { |pos| grid[pos] }
  # Calculate biodiversity, adding increasing powers of two.
  array.map.with_index { | value, index | (value == "#") ? 2 ** index : 0 }.sum
end

mem = []

while true do
  neighbor_count = count_neighbor_bugs(grid)
  grid = live_and_let_die(grid, neighbor_count)

  rating = biodiversity(grid)

  if mem.include?(rating)
    puts rating
    break
  else
    mem << rating
  end
end
