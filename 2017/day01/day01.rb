while line = gets
  digits = line.strip.chars.map(&:to_i)
  sum = 0
  digits.push(digits[0]) # Add first digit to the end.
  digits.each.with_index do |digit, index| 
    sum += digit if digit == digits[index+1]	
  end
  puts sum  
end
