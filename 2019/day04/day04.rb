RANGE = (248345..746315)  # TODO Read input file properly.

count = 0

# Rule: The value is within the range given in your puzzle input.
RANGE.each do |number|
  puts number
  # Rule: It is a six-digit number.
  if number.to_s.length == 6 &&
     # Rule : Two adjacent digits are the same (like 22 in 122345).
     number.to_s.chars.uniq.length <= 5 &&
     # Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
     number.to_s.chars.sort == number.to_s.chars
  then   
    count += 1
  end

end

puts count