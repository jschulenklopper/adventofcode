difference = 0
while line = gets
  line = line.chomp

  original = line.length
  encoded = line.dump.length
  difference += original - encoded
end
puts difference