count = 0
lines = []
while line = gets do
  lines << line.split(" ").map(&:to_i)
end

lines.transpose.flatten.each_slice(3).each do |sides|
  sides = sides.sort
  count += 1 if (sides[0] + sides[1]) > sides[2]
end

puts count