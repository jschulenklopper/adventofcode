def new_row(cur_row)
  cur_row.chars.each_index.map { |i|
    left = (i-1 >= 0) ? cur_row[i-1] : "."
    center = cur_row[i]
    right = (i+1 <= cur_row.length - 1) ? cur_row[i+1] : "."
    adjecent = left + center + right
    if adjecent == "^^." ||  # Its left and center tiles are traps, but its right tile is not.
       adjecent == ".^^" ||  # Its center and right tiles are traps, but its left tile is not.
       adjecent == "^.." ||  # Only its left tile is a trap.
       adjecent == "..^"     # Only its right tile is a trap.
      "^"
    else
      "."
    end
  }.join
end

input = gets.strip

grid = [input]  # Fill grid with first line.

ROWS = 40
# ROWS = 400000  # Part two of puzzle.

until grid.length == ROWS
  grid << new_row(grid.last)
end

puts grid.join.chars.count(".")