checksum = 0
while line = gets
  values = line.strip.split(" ").map(&:to_i)
  divisors = values.select { |i|
    values.select { |j|
      i != j && ( (i % j) == 0 || (j % i) == 0)
    }.length > 0
  }
  checksum += divisors.max / divisors.min
end
puts checksum  
