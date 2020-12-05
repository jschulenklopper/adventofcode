passes = ARGF.readlines.map(&:strip)

puts "part 1"
seats = passes.map { |pass|
   # Compute seat ID.
   pass[0,7].gsub(/[FB]/, 'F' => "0", 'B' => "1").to_i(2) * 8 +
   pass[7,3].gsub(/[LR]/, 'L' => "0", 'R' => "1").to_i(2)
}
puts seats.max

puts "part 2"
# Find missing seat by subtracting the seat list from the
# range of all seats between the minimum and maximum seat.
puts (seats.min .. seats.max).to_a - seats
