exactly_two, exactly_three = 0,0

# Process all lines.
while line = gets
    # Build a frequency map for all characters in line.
    memo = Hash.new(0)
    line.strip.chars.each { |char|
        memo[char] += 1
    }

    # Increase counters if conditions met.
    exactly_two += 1 if memo.values.include?(2)
    exactly_three += 1 if memo.values.include?(3)
end

puts exactly_two * exactly_three