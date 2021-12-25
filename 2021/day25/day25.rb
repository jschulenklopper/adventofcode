floor = ARGF.readlines.map(&:strip).map(&:chars)
width, height = floor.first.length, floor.length

step = 0

while true
  step += 1
  new_floor = floor.map { |r| r.clone } # Ugly way to copy array.

  # FIXME This is ugly: two loops for similar behavior.

  # Move right-moving herd.
  floor.each.with_index do |row,r|
    row.each.with_index do |col,c|
      if col == ">"
        inspect = [r, (c+1) % width]
      else # col == "."
        next
      end
      nr, nc = inspect
      if floor[nr][nc] == "."
        new_floor[nr][nc] = col
        new_floor[r][c] = "."
      end
    end
  end

  newer_floor = new_floor.map { |r| r.clone }

  # Move down-moving herd.
  floor.each.with_index do |row,r|
    row.each.with_index do |col,c|
      if col == "v"
        inspect = [(r+1) % height, c]
      else # col == "."
        next
      end
      nr, nc = inspect
      if new_floor[nr][nc] == "."
        newer_floor[nr][nc] = col
        newer_floor[r][c] = "."
      end
    end
  end

  break if floor == newer_floor

  floor = newer_floor
end

puts "part 1"
puts step
