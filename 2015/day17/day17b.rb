def combinations(containers)
  start = 0
  finish = 2 ** containers.length-1

  (start..finish).each do |number|
    result = []
    binary = number.to_s(2).reverse
    containers.map.with_index do |container, index|
      result << container if binary[index] == "1"
    end
    yield result
  end
end

containers = Array.new

while line = gets do 
  containers << line.to_i
end

possible_distributions = []
min_length = containers.length

# Generate all possible combinations of containers.
combinations(containers) do |combination|
  # Only store those that total up to 150.
  if combination.reduce(:+) == 150
    possible_distributions << combination
    min_length = combination.length if combination.length < min_length
  end
end

# Count the number of combinations with minimum length.
puts possible_distributions.reject { |d| d.length != min_length }.length