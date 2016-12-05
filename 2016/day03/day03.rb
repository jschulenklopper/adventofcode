count = 0
while line = gets do
  sides = line.split(" ").map(&:to_i).sort
  count += 1 if (sides[0,2]).reduce(:+) > sides[2]
end
puts count
