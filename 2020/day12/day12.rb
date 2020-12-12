navigations = ARGF.readlines.map { |line| line.match(/([NSEWLRF])(\d+)/).captures }
instructions = navigations.map { |action, value| [ action.to_sym, value.to_i ] }

# Lambda functions to work on position and direction, using action and value.
# Each lambda function returns new position and direction.
moves = { N: lambda { |value, pos, dir| [ [ pos[0] += value, pos[1] ], dir ] },
          S: lambda { |value, pos, dir| [ [ pos[0] -= value, pos[1] ], dir ] },
          E: lambda { |value, pos, dir| [ [ pos[0], pos[1] += value ], dir ] },
          W: lambda { |value, pos, dir| [ [ pos[0], pos[1] -= value ], dir ] },
          L: lambda { |value, pos, dir| [ pos, dir -= value ] },
          R: lambda { |value, pos, dir| [ pos, dir += value ] },
          F: lambda { |value, pos, dir|
                case (dir % 360)
                  when   0 then [ [ pos[0], pos[1] + value ], dir ]
                  when  90 then [ [ pos[0] - value, pos[1] ], dir ]
                  when 180 then [ [ pos[0], pos[1] - value ], dir ]
                  when 270 then [ [ pos[0] + value, pos[1] ], dir ]
                end } }

puts "part 1"

# Starting position, [0,0] in [north, east]
position = [0,0] 
# Starting direction is facing east (in degrees)
direction = 0

instructions.each do |action, value|
  position, direction = moves[action].call(value, position, direction)
end

# Compute Manhattan distance of position.
puts position[0].abs + position[1].abs

puts "part 2"

# Lambda function to move the waypoint. Functions take waypoint and return it too.
waypoint_moves = {
          N: lambda { |value, pos, wp| [ pos, [ wp[0] += value, wp[1] ] ] },
          S: lambda { |value, pos, wp| [ pos, [ wp[0] -= value, wp[1] ] ] },
          E: lambda { |value, pos, wp| [ pos, [ wp[0], wp[1] += value ] ] },
          W: lambda { |value, pos, wp| [ pos, [ wp[0], wp[1] -= value ] ] },
          L: lambda { |value, pos, wp|
                case value
                  when   0 then [ pos, [  wp[0],  wp[1] ] ]
                  when  90 then [ pos, [  wp[1], -wp[0] ] ]
                  when 180 then [ pos, [ -wp[0], -wp[1] ] ]
                  when 270 then [ pos, [ -wp[1],  wp[0] ] ]
                end },
          R: lambda { |value, pos, wp|
                case value
                  when   0 then [ pos, [  wp[0],  wp[1] ] ]
                  when  90 then [ pos, [ -wp[1],  wp[0] ] ]
                  when 180 then [ pos, [ -wp[0], -wp[1] ] ]
                  when 270 then [ pos, [  wp[1], -wp[0] ] ]
                end },
          F: lambda { |value, pos, wp| [ [ pos[0] + value * wp[0], pos[1] + value * wp[1] ], wp ] }
        }

# Starting position, [0,0] in [north, east]
position = [0,0] 
# Starting position of waypoint, [north, east]
waypoint = [1, 10]

instructions.each do |action, value|
  position, waypoint = waypoint_moves[action].call(value, position, waypoint)
end

# Compute Manhattan distance of position.
puts position[0].abs + position[1].abs
