position = [0, 0]  # Starting position
orientation = 0 # North is 0, East is 1, South is 2, West is 3

while line = gets do # Assume that instructions span multiple lines.
  instructions = line.strip.split(", ")
  
  instructions.each do | instruction |
    turn, distance = instruction[0], instruction[1..-1].to_i
    turn == "R" ? orientation += 1 : orientation += -1

    case orientation % 4
    when 0
      position[0] += distance
    when 1
      position[1] += distance
    when 2
      position[0] -= distance
    when 3
      position[1] -= distance
    end
  end
end

puts position[0].abs + position[1].abs
