# Find the (x,y)-position of n in a Ulam spiral.
def position(n)
  higher_square = Math.sqrt(n).ceil**2
  lower_square = Math.sqrt(n).floor**2
  range_length = Math.sqrt(higher_square).floor
  
  x, y = nil, nil
  if higher_square.even?
    if n.between?(higher_square - range_length + 1, higher_square)
      x = higher_square - n - range_length/2  + 1
      y = (Math.sqrt(n)/2).ceil
    else
      x = (Math.sqrt(n)/2).ceil
      y = n  - higher_square + range_length + range_length/2 - 1
    end
  else # higher_square.odd?
    if n.between?(higher_square - range_length + 1, higher_square)
      x = n -	higher_square + range_length/2
      y = -1 * (Math.sqrt(n)/2).floor
    else
      x = -1 * (Math.sqrt(n)/2).floor	
      y = higher_square - n - range_length - (range_length - 1)/2 + 1
    end
  end
  return [x, y]
end

# Compute Manhattan distance from position to (0,0)
def distance(position)
  return nil if position[0] == nil || position[1] == nil
  position[0].abs + position[1].abs
end

n = gets.strip.to_i
puts distance(position(n))
