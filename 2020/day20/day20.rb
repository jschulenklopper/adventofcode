# Read all tiles.
def read_tiles(file)
  tiles = {}
  lines = file.readlines.map(&:strip) + [""]
  tile_id, tile, row = nil, [], 0
  lines.each do |line|
    # Match start of new tile containing tile id.
    if match = line.match(/Tile (\d*):/)
      tile_id = match.captures.first.to_i
    # Add tile to tiles when tile is read completely.
    elsif line.empty?
      tiles[tile_id] = tile
      row = 0
      tile = []
    else
      tile << line.chars.to_a
      row += 1
    end
  end
  tiles
end

# Remove edges of tile.
def remove_edges(tile)
  tile[1..tile.length-2].map { |row| row[1..row.length-2] }
end

# Return all possible edges of tile.
def all_edges(tile)
  edges(tile) + edges(tile).map(&:reverse)
end

# Return edges of tile.
def edges(tile)
  [tile.first, tile.last, tile.transpose.first, tile.transpose.last]
end

def edges_match?(one_edge, another_edge)
  one_edge == another_edge
end

def tiles_match?(one_tile, other_tile)
  all_edges(one_tile).intersection(all_edges(other_tile)).count > 0
end

# Rotate tile number of times (clockwise).
def rotate(tile, turns)
  turns.times do
    tile = tile.reverse.transpose
  end
end

# Flip tile, vertically.
def flip(tile)
  tile.reverse  # transpose
end

def string(tile)
puts "---"
  return nil if tile == nil || tile == []
  str = ""
  tile.each { |row|
    str += "#{row.join(" ")}\n"
  }
  str
end

# Read tiles into hash (tile_id => tile). Each tile is an array of arrays.
$tiles = read_tiles(ARGF)

puts "part 1"

# Find all tiles of which (two adjecent) edges don't match any other edge.
corners = []
$tiles.each do |id, tile|
  if $tiles.count { |_, other| tiles_match?(tile, other) } == 3
    corners << id.to_i
  end
end

puts corners.reduce(:*)
