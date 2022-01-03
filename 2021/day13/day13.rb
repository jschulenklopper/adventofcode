dots, instructions, paper = [], [], Hash.new

ARGF.readlines.map(&:strip).each do |line|
  if match = line.match(/(\d+),(\d+)/)
    x,y = match.captures.map(&:to_i)
    paper[ [x,y] ] = "*"
  elsif match = line.match(/fold along (\w)=(\d+)/)
    instructions << [match.captures[0], match.captures[1].to_i]
  end
end

instructions.each do |direction, foldline|
  paper.keys.each do |x,y|
    if direction == "x" && x > foldline  # Fold left
      paper[ [2*foldline - x,y] ] = paper[ [x,y] ]
      paper.delete([x,y])
    elsif direction == "y" && y > foldline  # Fold up
      paper[ [x, 2*foldline - y] ] = paper[ [x,y] ]
      paper.delete([x,y])
    end
  end
end

line = ""
(0 .. paper.keys.map(&:last).max).each do |y|
  (0 .. paper.keys.map(&:first).max).each do |x|
    line += paper.key?( [x,y] ) ? "*" : " "
  end
  line += "\n"
end

puts "part 2"
puts line
