forest = Hash.new
DIMENSIONS = 50
MAX_TIME = 10

def string(forest)
  line = ""
  DIMENSIONS.times do |y|
    DIMENSIONS.times do |x|
      line += forest[ [x,y] ]
    end
    line += "\n"
  end
  line
end

# Read forest.
# The lumber collection area is 50 acres by 50 acres; each acre can be
# either open ground (.), trees (|), or a lumberyard (#)
y = 0
while line = gets
  x = 0
  line.strip.chars.each do |c|
    forest[ [x,y] ] = c
    x += 1
  end
  y += 1
end

puts string(forest)

time = 0
while time < MAX_TIME
  # Duplicate forest, use that to investigate.
  acres = forest.dup
  acres.each do |coor, area|
    # puts "---"
    # puts coor.to_s

    # Gather adjacent areas.
    adjacent = acres.select { |pos, v|
      ! (pos[0] == coor[0] && pos[1] == coor[1]) && 
      (coor[0]-1 .. coor[0]+1).map.include?(pos[0]) && 
      (coor[1]-1 .. coor[1]+1).map.include?(pos[1])
    }

    # An open acre will become filled with trees if three or more adjacent
    # acres contained trees. Otherwise, nothing happens.
    # puts "tree count: " + adjacent.select { |_, acre| acre == "|" }.count.to_s
    if area == "." && adjacent.select { |_, acre| acre == "|" }.count >= 3 
      # puts "tree++"
      forest[coor] = "|"
    end

    # An acre filled with trees will become a lumberyard if three or more
    # adjacent acres were lumberyards. Otherwise, nothing happens.
    # puts "lumberyard count: " + adjacent.select { |_, acre| acre == "#" }.count.to_s
    if area == "|" && adjacent.select { |_, acre| acre == "#" }.count >= 3 
      # puts "lumberyard++"
      forest[coor] = "#"
    end

    # An acre containing a lumberyard will remain a lumberyard if it was
    # adjacent to at least one other lumberyard and at least one acre
    # containing trees. Otherwise, it becomes open.
    if area == "#"
      if adjacent.select { |_, acre| acre == "#" }.count >= 1  && 
         adjacent.select { |_, acre| acre == "|" }.count >= 1
        # puts "lumberyard++"
        forest[coor] = "#"
      else
        # puts "open++"
        forest[coor] = "."
      end
    end

  end

  puts
  puts string(forest)

  time += 1
end

nr_trees = forest.count { |_, v| v == "|" }
nr_lumberyards = forest.count { |_, v| v == "#" }

puts nr_trees * nr_lumberyards



