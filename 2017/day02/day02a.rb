checksum = 0
while line = gets
  values = line.strip.split(" ").map(&:to_i)
  checksum += values.max - values.min
end
puts checksum  