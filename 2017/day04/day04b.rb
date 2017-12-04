valid = 0
while line = gets
  words = line.strip.split(" ")
  valid += 1 if words.map { |w| w.chars.sort }.uniq.length == words.length
end
puts valid
