heightmap = ARGF.readlines.map(&:strip).map(&:chars).map { |r| r.map(&:to_i) }

# Find all the neighbors of location [r,c].
def neighbors(location)
  r,c = location
  [ [r-1,c],[r+1,c],[r,c-1],[r,c+1] ].filter { |i,j| [i,j].min >= 0 }.compact
end

# Get the (valid) heights for a list of locations on a heightmap.
def heights(map, locations)
  locations.map { |i,j| map[i][j] if map[i] }.compact
end

# Use recursive call to find higher neighbors.
def higher_neighbors(map, location)
  r,c = location

  neighbors = neighbors(location)
  higher = neighbors.select { |i,j|
    map[i][j] > map[r][c] if map[i] && map[i][j] && map[i][j] != 9 }
  even_higher = higher.map { |loc| higher_neighbors(map, loc) }

  # Return list of all positions that are higher than `location`.
  ([location] + higher + even_higher.flatten(1)).uniq
end

puts "part 1"

# Find all low points in the map.
lowpoints = heightmap.map.with_index do |row, r|
  row.map.with_index do |point, c|
    # Collect valid neighbors and their heights
    # ... and compare those with the current point.
    # If so, yield the location.
    [r,c] if point < heights(heightmap, neighbors([r,c])).min
  end
# Remove the `nil` locations.
end.flatten(1).compact

# Compute sum of scores for all low points.
puts lowpoints.map { |r,c| 1 + heightmap[r][c] }.sum

puts "part 2"

# For all lowpoints
basins = lowpoints.map do |r,c|
  # ... continue to find neighbors
  # ... that are higher than current position but not 9
  # ... and return the size of the basin to the list.
  higher_neighbors(heightmap, [r,c]).size
end

puts basins.sort.reverse[0..2].reduce(&:*)
