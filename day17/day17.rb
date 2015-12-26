def distribute(amount, containers, level)
  # puts "%s distribute(%d, %s)" % [" "*level, amount, containers.to_s]

  return 1 if amount == 0
  return 0 if amount < 0 || containers.empty?

  remaining = containers.clone
  first = remaining.pop

  return distribute(amount - first, remaining, level+1) +
         distribute(amount, remaining, level+1)
end

containers = Array.new

while line = gets do 
  containers << line.to_i
end

# puts containers.to_s

puts distribute(150, containers, 0)
