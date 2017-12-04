valid = 0
while line = gets
  words = line.strip.split(" ")
  valid += 1 if words.uniq.length == words.length
end
puts valid
