t = 0

all_right = false
until all_right
  puts "t: %d" % t
  right_time = ""  # String of bits, "1" is correct time. 

  # right_time += ((4 + t+1) % 5) == 0 ? "1" : "0"
  # right_time += ((1 + (t+2)) % 2) == 0 ? "1" : "0"
  right_time += ((0 + t+1) % 7) == 0 ? "1" : "0"
  right_time += ((0 + t+2) % 13) == 0 ? "1" : "0"
  right_time += ((2 + t+3) % 3) == 0 ? "1" : "0"
  right_time += ((2 + t+4) % 5) == 0 ? "1" : "0"
  right_time += ((0 + t+5) % 17) == 0 ? "1" : "0"
  right_time += ((7 + t+6) % 19) == 0 ? "1" : "0"

  # Disc #1 has 7 positions; at time=0, it is at position 0.
  # Disc #2 has 13 positions; at time=0, it is at position 0.
  # Disc #3 has 3 positions; at time=0, it is at position 2.
  # Disc #4 has 5 positions; at time=0, it is at position 2.
  # Disc #5 has 17 positions; at time=0, it is at position 0.
  # Disc #6 has 19 positions; at time=0, it is at position 7.

  puts "right_time: %s" % right_time
  puts "length: %d, 1-count: %d" % [right_time.length, right_time.chars.count { |c| c == "1" }]

  all_right = right_time.chars.count { |c| c == "1" } == right_time.length

  t += 1 unless all_right
end

puts t
