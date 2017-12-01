while line = gets
  digits = line.strip.chars.map(&:to_i)
  sum = 0
  digits.each.with_index do |digit, index| 
    other_digit = (index + digits.length / 2) % digits.length
    sum += digit if digit == digits[other_digit]	
  end
  puts sum  
end
