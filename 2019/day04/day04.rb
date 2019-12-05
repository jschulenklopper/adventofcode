RANGE = (248345..746315)  # TODO Read input file properly.

count = 0

# Rule: The value is within the range given in your puzzle input.
RANGE.each do |num|
  number = num.to_s
  # Rule: It is a six-digit number.
  if number.length == 6 &&
     # Rule : Two adjacent digits are the same (like 22 in 122345).
     number.scan(/(.)\1{1,}/).length >= 1 && 
     # Rule: going from left to right, the digits never decrease.
     number.chars.sort == number.chars
  then   
    count += 1
  end

end

puts count