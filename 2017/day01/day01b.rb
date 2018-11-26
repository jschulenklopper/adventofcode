while line = gets
  digits = line.strip.chars.map(&:to_i)
  puts digits.reject.each_with_index { |digit, i|
    # Replace `digits.length/2` by `1` for first puzzle.
    digits[i] != digits[ (i + digits.length/2) % digits.length]
  }.sum
end