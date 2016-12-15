# Read input file.
discs = []
while line = gets
  # Disc #<id> has <number> positions; at time=<time>, it is at position <start>
  match = line.match(/Disc #\d+ has (?<number>\d+) posi\D+\d+, \D+tion (?<start>\d+)\./)
  discs << [ match[:start].to_i, match[:number].to_i ] 
end

t = 0
all_right = false

until all_right
  right_time = ""  # String of bits, "1" is correct time. 

  # Test whether all discs are in correct position when starting on t.
  discs.each_with_index do |disc, index|
    # Test if starting position plus time+1 modulo number of positions equals 0.
    right_time += ((disc[0] + t+1+index) % disc[1]) == 0 ? "1" : "0"
  end

  # Time is right if all positions were right.
  all_right = right_time.chars.count { |c| c == "1" } == right_time.length

  t += 1 unless all_right
end

puts t
