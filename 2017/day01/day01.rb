while line = gets
  digits = line.strip.chars.map(&:to_i)
  sum = 0

  digits.each.with_index do |digit, index| 
    sum += digit if digit == digits[(index+1) % digits.length]	
  end
  puts sum  
end
