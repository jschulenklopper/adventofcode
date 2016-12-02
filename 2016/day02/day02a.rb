directions = { "U" => [0,-1], "D" => [0,+1], "L" => [-1,0], "R" => [+1,0] }

# Grid with the valid keys (and the invalid marked as nil).
keys =  [["1","2","3"],
         ["4","5","6"],
         ["7","8","9"]]

# Make the X and Y more logical by transposing matrix, `keys[0][2] == "7"`.
keys = keys.transpose

position = [1,1]  # Starting position.
code = ""

while instructions = gets do
  instructions.strip.chars.each do | instruction |
    # Compute new candidate position.
    new_position = [position[0] + directions[instruction][0],  # X-value
                    position[1] + directions[instruction][1]]  # Y-value

    # Check whether new_position is within valid grid.
    if new_position[0].between?(0,2) && new_position[1].between?(0,2)
      position = [new_position[0],new_position[1]]
    end
  end

code << keys[position[0]][position[1]]
end

puts code
