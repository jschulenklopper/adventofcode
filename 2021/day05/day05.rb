lines = ARGF.readlines.map(&:strip)
vents = Array.new

lines.each do |line|
  c = line.match(/(\d+),(\d+) -> (\d+),(\d+)/).captures.map(&:to_i)
  vents << [c[0], c[1], c[2], c[3]]
end

grid = Hash.new { |k,v| 0 }

# Process the horizontal lines.
vents.each do |fx, fy, tx, ty|
  next unless fx == tx || fy == ty

  if fx > tx then fx,tx = tx,fx end
  if fy > ty then fy,ty = ty,fy end
  (fx .. tx).each do |x|
    (fy .. ty).each do |y|
      grid[ [x,y] ] += 1
    end
  end
end

puts "part 1"
puts grid.values.select { |v| v > 1 }.count

# Process the diagonal lines.
vents.each do |fx, fy, tx, ty|
  next if (fx == tx || fy == ty)

  if fx > tx then dx = -1 else dx = 1 end
  if fy > ty then dy = -1 else dy = 1 end
  ((fx-tx).abs + 1).times do
    grid[ [fx,fy] ] += 1
    fx += dx
    fy += dy
  end
end

puts "part 2"
puts grid.values.select { |v| v > 1 }.count
