grid_size = 300
grid = Hash.new 
square_size = 3

p serial = gets.strip.to_i

(1..grid_size).each do |x|
  (1..grid_size).each do |y|
    rack_id = x + 10
    power_level = rack_id * y
    power_level += serial
    power_level *= rack_id
    power_level = (power_level.abs.to_s.length < 3) ? 0 : (power_level / 100).floor.to_s[-1].to_i
    power_level -= 5
    grid[ [x,y] ] = power_level
  end
end

powers = Hash.new

(1 .. grid_size-square_size).each do |x|
  (1 .. grid_size-square_size).each do |y|
    squares = (x .. x+square_size-1).map { |sx| (y .. y+square_size-1).map { |sy| grid[ [sx,sy] ] } }.flatten
    power = squares.sum
    powers[ [x,y] ] = power
  end
end

p powers.each.max_by { |k, v| v }