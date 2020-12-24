lines = ARGF.readlines.map(&:strip)

# Floor tiles stored in hash; coordinate [x,y,z] where x + y  + z = 0.
floor = {}

moves = { e: lambda { | pos | [ pos[0]+1, pos[1]-1, pos[2] ] },
          D: lambda { | pos | [ pos[0], pos[1]-1, pos[2]+1 ] },  # sw
          B: lambda { | pos | [ pos[0]-1, pos[1], pos[2]+1 ] },  # se
          w: lambda { | pos | [ pos[0]-1, pos[1]+1, pos[2] ] },
          O: lambda { | pos | [ pos[0], pos[1]+1, pos[2]-1 ] },  # nw
          U: lambda { | pos | [ pos[0]+1, pos[1], pos[2]-1 ] }   # ne
        }

puts "part 1"

lines.each do |line|
  position = [0,0,0]
  line = line.gsub(/(se)/, "D").gsub(/sw/, "B").gsub(/nw/, "O").gsub(/ne/, "U")
  line.chars.each { |move| position = moves[move.to_sym].call(position) }
  floor[position] ||= "."
  floor[position] = (floor[position] == ".") ? "#" : "."
end

puts floor.values.count("#")

puts "part 2"

f_neighbors = lambda { |position| %i(e D B w O U).map { |m| moves[m].call(position) } }

100.times do |i|
  # Build list of tiles not yet considered (but need to be considered). 
  new_positions = []
  floor.each do |position, _|
    # Find neighbors of position.
    possible_positions = f_neighbors.call(position)
    possible_positions.each { |pos|
      new_positions << pos unless floor.key?(pos) || new_positions.include?(pos)
    }
  end

  # Extend floor with neighboring white tiles.
  new_positions.each { |pos| floor[pos] = "." }

  # For each tile (in enlarged floor) count number of black neighbor tiles.
  nr_black_neighbors = {}
  floor.each do |position, _|
    nr_black_neighbors[position] = f_neighbors.call(position).count { |pos| floor[pos] == "#" }
  end

  nr_black_neighbors.each do |position, count|
    if floor[position] == "#" && (count == 0 || count > 2)
      floor[position] = "."
    elsif floor[position] == "." && (count == 2)
      floor[position] = "#"
    end
  end
end

puts floor.values.count("#")
