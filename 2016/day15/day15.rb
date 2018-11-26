# Read input file.
discs = []
while line = gets
  # Disc #<id> has <number> positions; at time=<time>, it is at position <start>
  match = line.match(/Disc #\d+ has (?<number>\d+) posi\D+\d+, \D+tion (?<start>\d+)\./)
  discs << [ match[:start].to_i, match[:number].to_i ] 
end

t = 0
all_right = false

# Test whether all discs are in correct position when starting on t.
until all_right
  correct = 0
  discs.each_with_index do |disc, index|
    # Test if starting position plus index+1+time modulo number of positions equals 0.
    correct += 1 if ((disc[0] + t+index+1) % disc[1]) == 0
  end

  # Time is right if all positions were right.
  all_right = (correct == discs.length) ? true : false

  t += 1 unless all_right
end

puts t