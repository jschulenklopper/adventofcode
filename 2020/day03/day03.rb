forest = ARGF.readlines.map(&:strip).map(&:chars)
TREE = "#"

NR_COLUMNS = forest.first.length
NR_ROWS = forest.length


puts "part 1"

slope = [3, 1]  # Steps right, steps down.
nr_trees = 0

row, column = 0, 0
until row >= NR_ROWS
  nr_trees +=1 if forest[row][column % NR_COLUMNS] == TREE
  column += slope.first
  row += slope.last
end

puts nr_trees


puts "part 2"

slopes = [ [1,1], [3,1], [5,1], [7,1], [1,2] ]
multiple_trees = 1

slopes.each do |right, down|
  nr_trees = 0
  row, column = 0, 0
  until row >= NR_ROWS
    nr_trees +=1 if forest[row][column % NR_COLUMNS] == TREE
    column += right
    row += down
  end
  multiple_trees *= nr_trees
end

puts multiple_trees
