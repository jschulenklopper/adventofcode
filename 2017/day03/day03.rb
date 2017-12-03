# Find the (x,y)-position of n in a Ulam spiral.
def position(n)
  higher_square = Math.sqrt(n).ceil**2
  lower_square = Math.sqrt(n).floor**2
  range_length = Math.sqrt(higher_square).floor
  puts "   l: %s" % range_length
  
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

(5..9).each do |n|
# (17..25).each do |n|
# (10..16).each do |n|
# (26..36).each do |n|
  pos = position(n) 
  puts "n: %s, (%s, %s)" % [n, pos[0], pos[1]]
  puts "  d: %s" % distance(pos)
end

raise "distance(16) not correct" if not distance(position(16)) == 3
raise "distance(15) not correct" if not distance(position(15)) == 2
raise "distance(14) not correct" if not distance(position(14)) == 3
raise "distance(13) not correct" if not distance(position(13)) == 4

raise "distance(1) not correct" if not distance(position(1)) == 0
raise "distance(12) not correct" if not distance(position(12)) == 3
raise "distance(23) not correct" if not distance(position(23)) == 2
raise "distance(1024) not correct" if not distance(position(1024)) == 31

n = gets.strip.to_i
puts "n: %s" % n
puts distance(position(n))
