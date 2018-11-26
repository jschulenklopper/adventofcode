difference = 0
while line = gets
  line = line.chomp

  original = line.length
  encoded = eval(line).length
  difference += original - encoded
end
puts difference