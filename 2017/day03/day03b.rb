# Find the (x,y)-position of n in a number spiral.
def position(n)
  higher_square = Math.sqrt(n).ceil**2
  range_length = Math.sqrt(higher_square).to_i
  
  x, y = nil, nil
  if higher_square.even?
    if n.between?(higher_square - range_length + 1, higher_square)
      x = higher_square - n - range_length/2  + 1
      y = (Math.sqrt(n)/2).ceil
    else
      x = (Math.sqrt(n)/2).ceil
      y = n  - higher_square + range_length + range_length/2 - 1
    end
  elsif higher_square.odd?
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

input = gets.strip.to_i
max_square = Math.sqrt(input).ceil**2

memo = {}
memo[ [0,0] ] = 1

(2..max_square).each do |n|
  pos = position(n)
  neighbors = [-1,0,1].map { |dx| [-1,0,1].map { |dy| [pos[0] + dx, pos[1] + dy ] } }.flatten(1)
  neighbors.delete(pos)
  memo[pos] = neighbors.reduce(0) { |sum, pos| memo[pos] ? sum + memo[pos] : sum }

  if memo[pos] > input
    puts memo[pos]
    break
  end
end
