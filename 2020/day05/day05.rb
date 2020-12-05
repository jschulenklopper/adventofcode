passes = ARGF.readlines.map(&:strip)

puts "part 1"

# Build up list of seat IDs.
seats = passes.map { |pass|
   row = pass[0,7].gsub("F","0").gsub("B","1").to_i(2)
   col = pass[7,3].gsub("L","0").gsub("R","1").to_i(2)
   row * 8 + col
}
puts seats.max


puts "part 2"

# Find missing seat by subtracting the seat list from a
# complete range of all seats between the minimum and maximum.
puts (seats.min .. seats.max).to_a - seats.sort
