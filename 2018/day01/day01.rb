freq = 0  # Start frequency.

while line = gets
  freq += line.strip.to_i  # Add delta to frequency.
end

puts freq