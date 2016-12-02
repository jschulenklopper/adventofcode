directions = { "U" => [0,-1], "D" => [0,+1], "L" => [-1,0], "R" => [+1,0] }

# Grid with the valid keys (and the invalid marked as nil).
keys =  [[nil,nil,"1",nil,nil],
         [nil,"2","3","4",nil],
         ["5","6","7","8","9"],
         [nil,"A","B","D",nil],
         [nil,nil,"D",nil,nil]]

# Make the X and Y more logical by transposing matrix, `keys[0][2] == "5"`.
keys = keys.transpose

position = [0,2]  # First column (X) and third row (Y).
code = ""

while instructions = gets do
  instructions.strip.chars.each do | instruction |
    # Compute new candidate position.
    new_position = [position[0] + directions[instruction][0],  # X-value
                    position[1] + directions[instruction][1]]  # Y-value

    # Check whether new_position is within valid grid.
    if new_position[0].between?(0,4) && new_position[1].between?(0,4) &&
       keys[new_position[0]][new_position[1]]
    then
      position = [new_position[0],new_position[1]]
    end
  end

  code << keys[position[0]][position[1]]
end

puts code
