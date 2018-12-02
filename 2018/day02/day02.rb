exactly_two, exactly_three = 0,0

# Process all lines.
while line = gets
    memo = Hash.new(0)
    # Build a frequency map for all characters in line.
    freq_map = line.strip.chars.reduce() { |char|
        memo[char] += 1
    }
    # Increase counters if conditions met.
    exactly_two += 1 if freq_map.values.include?(2)
    exactly_three += 1 if freq_map.values.include?(3)
end

puts exactly_two * exactly_three