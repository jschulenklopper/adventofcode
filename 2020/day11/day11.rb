$layout = Hash.new

# Read seat layout.
ARGF.readlines.each.with_index { |row, r|
  row.strip.chars.each.with_index { |seat, c|
    $layout[[r,c]] = seat
  }
}

def count_in_sight(layout, key, adjacent)
  deltas = [ [-1,-1], [-1, 0], [-1, +1],
             [ 0,-1],          [ 0, +1],
             [+1,-1], [+1, 0], [+1, +1] ]
  # Investigate all seats in sight in all directions.
  deltas.select { |delta|
    found = false
    new_key = [ key[0], key[1] ]
    until found do
      # Apply delta (movement).
      new_key = [ new_key[0] + delta[0], new_key[1] + delta[1] ]
      # Check whether occupied seat has been found.
      found = true if layout[new_key] == "#"
      # Break if beyond the grid, at an empty seat, or just checking neighbors.
      break if layout[new_key] == nil || layout[new_key] == "L" || adjacent
    end
    found
  }.count
end

def round(layout, max_occupancy)
  new_layout = Hash.new

  layout.each do |key, seat|
    occupied = count_in_sight(layout,key, true) unless seat == "."
    case seat
      when "L" then new_layout[key] = (occupied == 0) ? "#" : layout[key]
      when "#" then new_layout[key] = (occupied >= max_occupancy) ? "L" : layout[key]
      else          new_layout[key] = layout[key]
    end
  end
  new_layout
end

puts "part 1"

layout = $layout
while true
  new_layout = round(layout, 4)
  break if layout == new_layout
  layout = new_layout
end

puts layout.select { |k,v| v == "#"}.count

puts "part 2"

layout = $layout
while true
  new_layout = round(layout, 5)
  break if layout == new_layout
  layout = new_layout
end

puts layout.select { |k,v| v == "#"}.count
