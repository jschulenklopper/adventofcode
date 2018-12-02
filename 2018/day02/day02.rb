exactly_two, exactly_three = 0,0

while line = gets
    chars = line.strip.chars
    freq_map = {}
    chars.each { |char|
        freq_map[char] = 0 unless freq_map[char]
        freq_map[char] += 1
    }
    exactly_two += 1 if freq_map.values.include?(2)
    exactly_three += 1 if freq_map.values.include?(3)
end

puts exactly_two * exactly_three