$layout = Hash.new

# Read seat layout.
ARGF.readlines.each.with_index { |row, r|
  row.strip.chars.each.with_index { |seat, c|
    $layout[[r,c]] = seat unless c == "."
  }
}

def count_in_sight(layout, key, just_neighbors)
  deltas = [ [-1,-1], [-1, 0], [-1, +1],
             [ 0,-1],          [ 0, +1],
             [+1,-1], [+1, 0], [+1, +1] ]
  # Investigate all seats in sight in all directions.
  deltas.select { |delta|
    found = false
    border = false
    new_key = [ key[0], key[1] ]
    until found || border do
      # Apply delta (movement).
      new_key = [ new_key[0] + delta[0], new_key[1] + delta[1] ]
      # Check whether border or neighbor has been found.
      border = true if layout[new_key] == nil || layout[new_key] == "L" || just_neighbors
      found = true if layout[new_key] == "#"
    end
    found
  }.count
end

def one_round(layout, threshold, just_neighbors)
  new_layout = Hash.new

  layout.each do |key, seat|
    occupied = count_in_sight(layout,key, just_neighbors) unless layout[key] == "."
    case seat
      when "L" then new_layout[key] = (occupied == 0) ? "#" : layout[key]
      when "#" then new_layout[key] = (occupied >= threshold) ? "L" : layout[key]
      else          new_layout[key] = layout[key]
    end
  end
  new_layout
end
puts "part 1"

layout = $layout
while true
  new_layout = one_round(layout, 4, true)
  break if layout == new_layout
  layout = new_layout
end

puts layout.select { |k,v| v == "#"}.count

puts "part 2"

layout = $layout
while true
  new_layout = one_round(layout, 5, false)
  break if layout == new_layout
  layout = new_layout
end

puts layout.select { |k,v| v == "#"}.count
