RANGE = (248345..746315)  # TODO Read input file properly.

count = 0

# Rule: The value is within the range given in your puzzle input.
# TODO This can be changed to a chain of map commands, which might look better.
RANGE.each do |num|
  number = num.to_s
  # Rule: It is a six-digit number.
  if number.length == 6 &&
     # Rule: Two adjacent digits are the same (like 22 in 122345).
     number.scan(/(.)\1{1,}/).length >= 1 && 
     # number.chars.uniq.length <= 5 &&
     # Rule: two adjacent matching digits are not part of a larger group of matching digits.
     number.scan(/(.)\1{1,}/).length > number.scan(/(.)\1{2,}/).length &&
     # Rule: going from left to right, the digits never decrease.
     number.chars.sort == number.chars
  then
    count += 1
  end

end

puts count