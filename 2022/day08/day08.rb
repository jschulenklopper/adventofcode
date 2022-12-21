grid = {}
ARGF.readlines.map.with_index.map { |line, y|
  line.strip.chars.map.with_index { |col, x|
    grid[[x,y]] = col.to_i
  }
}

visible = grid.count do |position, height|
  # Very inefficient to consider the whole grid to
  # construct the view lines for every position...
  left =  grid.select { |p|
    p[0] < position[0] && p[1] == position[1] }.values
  right = grid.select { |p|
    p[0] > position[0] && p[1] == position[1] }.values
  above = grid.select { |p|
    p[0] == position[0] && p[1] < position[1] }.values
  under = grid.select { |p|
    p[0] == position[0] && p[1] > position[1] }.values
  # A tree is visible if there are no larger trees in a direction.
  left.length == 0 || height > left.max ||
    right.length == 0 || height > right.max ||
    above.length == 0 || height > above.max ||
    under.length == 0 || height > under.max
end

puts "part 1"
puts visible


scores = grid.map do |position, height|
  left =  grid.select { |p|
    p[0] < position[0] && p[1] == position[1] }.values.reverse
  visible_left = (left+[height+1]).find_index { |h| h >= height}

  right = grid.select { |p|
    p[0] > position[0] && p[1] == position[1] }.values
  visible_right = (right+[height+1]).find_index { |h| h >= height}

  above = grid.select { |p|
    p[0] == position[0] && p[1] < position[1] }.values.reverse
  visible_above = (above+[height+1]).find_index { |h| h >= height}

  under = grid.select { |p|
    p[0] == position[0] && p[1] > position[1] }.values
  visible_under = (under+[height+1]).find_index { |h| h >= height}

  score = left[0 .. visible_left].length *
          right[0 .. visible_right].length *
          above[0 .. visible_above].length *
          under[0 .. visible_under].length
  score
end

puts "part 2"
puts scores.max
