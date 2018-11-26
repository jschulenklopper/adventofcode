directions = { "U" => -3, "D" => +3, "L" => -1, "R" => +1 }

digit = 5  # Starting digit.
code = ""

while instructions = gets do
  instructions.strip.chars.each do | instruction |
    # Compute next possible digit...
    candidate = digit + directions[instruction]
    # ... but test whether it is a valid one.
    if instruction == "L" && ! [1,4,7].include?(digit) ||
       instruction == "R" && ! [3,6,9].include?(digit) ||
       instruction == "U" && ! [1,2,3].include?(digit) ||
       instruction == "D" && ! [7,8,9].include?(digit) 
    then
      digit = candidate if candidate.between?(1,9)
    end
  end

  code << digit.to_s
end

puts code