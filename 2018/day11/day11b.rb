grid_size = 300
grid = Hash.new 

serial = gets.strip.to_i

def power(x, y, serial)
    rack_id = x + 10
    power_level = rack_id * y
    power_level += serial
    power_level *= rack_id
    power_level = (power_level.abs.to_s.length < 3) ? 0 : (power_level / 100).floor.to_s[-1].to_i
    power_level -= 5
end

# Fill grid.
# TODO This can be made nicer, for example by map() and iterating over the grid cells.
(1..grid_size).each do |x|
  (1..grid_size).each do |y|
    power = power(x, y, serial)
    grid[ [x,y] ] = power
  end
end

max_square = 15
maxes = Array.new(4, 0)

# Compute powers for all squares sized s starting at x,y.
(2 .. max_square).each do |square_size|
  (1 .. grid_size-square_size).each do |y|
    (1 .. grid_size-square_size).each do |x|

      new_x = square_size-1 + x
      new_y = square_size-1 + y

      # TODO This line is getting expensive to compute for larger squares,
      # because of many grid values to sum.
      # There should be a smarter solution, re-using previously computed values.
      # Something like (x,y,n) = (x,y+n-1,1) + (x+n-1,y,1) + (x,y,n-1) + (x+1,y+1,n-1) - (x+1,y+1,n-2)
      cell = (x .. new_x).map { |nx| (y .. new_y).map { |ny| grid[ [nx,ny] ] } }.flatten.sum

      if cell > maxes[3]
        maxes = [x,y,square_size,cell]
      end

    end
  end
end

puts maxes[0,3].join(",")