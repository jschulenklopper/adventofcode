navigations = ARGF.readlines.map { |line| line.match(/([NSEWLRF])(\d+)/).captures }
instructions = navigations.map do |action, value|
  [ action.to_sym, value.to_i ]
end

# Lambda functions to work on position and direction, using action and value.
# Each lambda function returns new position and direction.
moves = { N: lambda { |value, pos, dir| [ [ pos[0] += value, pos[1] ], dir ] },
          S: lambda { |value, pos, dir| [ [ pos[0] -= value, pos[1] ], dir ] },
          E: lambda { |value, pos, dir| [ [ pos[0], pos[1] += value ], dir ] },
          W: lambda { |value, pos, dir| [ [ pos[0], pos[1] -= value ], dir ] },
          L: lambda { |value, pos, dir| [ pos, dir -= value ] },
          R: lambda { |value, pos, dir| [ pos, dir += value ] },
          F: lambda { |value, pos, dir|
                case (dir % 360).to_s
                  when   "0" then [ [ pos[0], pos[1] + value ], dir ]
                  when  "90" then [ [ pos[0] - value, pos[1] ], dir ]
                  when "180" then [ [ pos[0], pos[1] - value ], dir ]
                  when "270" then [ [ pos[0] + value, pos[1] ], dir ]
                end
          }
        }

# Starting position, [0,0] in [north, east]
position = [0,0] 
# Starting direction is facing east (in degrees)
direction = 0

instructions.each do |action, value|
  position, direction = moves[action].call(value, position, direction)
end

# Compute Manhattan distance of position.
puts position[0].abs + position[1].abs
