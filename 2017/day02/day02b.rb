checksum = 0
while line = gets
  values = line.strip.split(" ").map(&:to_i)
  checksum += values.product(values).map { |i,j|
    (i % j == 0 && i != j) ? i / j : nil
  }.compact.first
end
puts checksum  
