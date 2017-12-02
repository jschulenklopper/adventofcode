checksum = 0
while line = gets
  values = line.strip.split(" ").map(&:to_i)
  divisors = values.select do |i|
    values.select { |j| (i % j) == 0 || (j % i) == 0 }.length > 1
  end
  checksum += divisors.max / divisors.min
end
puts checksum  
