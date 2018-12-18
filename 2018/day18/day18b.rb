forest = Hash.new
DIMENSIONS = 10 # 50
MAX_TIME = 1000000000

def string(forest)
  line = ""
  DIMENSIONS.times do |y|
    DIMENSIONS.times do |x|
      line += forest[ [x,y] ][0]
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
    forest[ [x,y] ] = [c, 0, 0] # :char, :nr_trees, :nr_lumberyards
    x += 1
  end
  y += 1
end

puts string(forest)

# TODO Enhance forest, register tree, open and lumberyard count for all acres.
def enhance(forest)
  # Process all the areas.
  puts forest.each { |pos, v|
    if ! (pos[0] == coor[0] && pos[1] == coor[1]) && 
       (coor[0]-1 .. coor[0]+1).map.include?(pos[0]) && 
       (coor[1]-1 .. coor[1]+1).map.include?(pos[1])
      v[0]
    else
      nil
    end
  }.compact

  # v[1] = adjacent.count("|")
  # v[2] = adjacent.count("#")
end

puts string(forest)
puts forest.to_s

exit

nr_trees = 0
nr_lumberyards = 0
score = 0

time = 0
while time < MAX_TIME
  # Duplicate forest, use that to investigate.
  acres = forest.dup
  acres.each do |coor, area|
    # puts "---"
    # puts coor.to_s

    # TODO This could be retrieved from enhanced acre data.
    tree_count = area[1] # adjacent.count("|")
    lumberyard_count = area[2] # adjacent.count("#")

    # An open acre will become filled with trees if three or more adjacent
    # acres contained trees. Otherwise, nothing happens.
    # puts "tree count: " + adjacent.select { |_, acre| acre == "|" }.count.to_s
    if area[0] == "." && tree_count >= 3 
      # puts "tree++"
      # TODO Change tree and open count for current acre.
      forest[coor] = "|"
    end

    # An acre filled with trees will become a lumberyard if three or more
    # adjacent acres were lumberyards. Otherwise, nothing happens.
    # puts "lumberyard count: " + adjacent.select { |_, acre| acre == "#" }.count.to_s
    if area[0] == "|" && lumberyard_count >= 3 
      # puts "lumberyard++"
      # TODO Change lumberyard and tree count for current acre.
      forest[coor] = "#"
    end

    # An acre containing a lumberyard will remain a lumberyard if it was
    # adjacent to at least one other lumberyard and at least one acre
    # containing trees. Otherwise, it becomes open.
    if area[0] == "#"
      if lumberyard_count >= 1  && 
         tree_count >= 1
        # puts "lumberyard++"
        forest[coor] = "#"
      else
        # puts "open++"
        # TODO Change open and lumberyard count for current acre.
        forest[coor] = "."
      end
    end

  end

  puts
  puts string(forest)

  time += 1

  prev_trees = nr_trees
  prev_lumberyards = nr_lumberyards
  prev_score = score

  nr_trees = forest.count { |_, v| v == "|" }
  nr_lumberyards = forest.count { |_, v| v == "#" }

  score = nr_trees * nr_lumberyards

  diff_trees = nr_trees - prev_trees
  diff_lumberyards = nr_lumberyards - prev_lumberyards
  diff_score = score - prev_score

  puts "time: %3i, trees: %i, lumber: %i, score: %i" % [time, nr_trees, nr_lumberyards, score]
  puts "           diff: %i, diff: %i, diff: %i" % [diff_trees, diff_lumberyards, diff_score]
end

# TODO Code pattern-finding in, instead of eyeballing it.

# With my input, pattern of length 28 establishes after est. 500.
# 528 has the same value.
# The position in the pattern for the requirement is
#   (1000000000 - 500) % 28 = 20 (or -4)
# So, the requested value will be at the 500-4 or 500+24 mark
#   233058