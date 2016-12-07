count = 0
pos_pattern = /([a-z])((?!\1).)\2\1/
neg_pattern = /\[.*([a-z])((?!\1).)\2\1[a-z]*\]/ 

while line = gets do
  count += 1 if line.match(pos_pattern) && !line.match(neg_pattern)
end

puts count
