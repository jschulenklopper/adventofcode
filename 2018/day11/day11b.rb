grid_size = 300
grid = Hash.new 
powers = Hash.new

serial = gets.strip.to_i
# serial = 18  # Sample input.

def power(x, y, serial)
    rack_id = x + 10
    power_level = rack_id * y
    power_level += serial
    power_level *= rack_id
    power_level = (power_level.abs.to_s.length < 3) ? 0 : (power_level / 100).floor.to_s[-1].to_i
    power_level -= 5
end

# Fill grid.
(1..grid_size).each do |x|
  (1..grid_size).each do |y|
    power = power(x, y, serial)
    grid[ [x,y] ] = power
    powers[ [x,y] ] = [power,1]  # powers[[x,y]] = [power, square_size]
  end
end

# Print grid.
(1..grid_size).each do |y|
  string = ""
  (1..grid_size).each do |x|
    string += "%3i" % grid[ [x,y] ]
  end
  # puts string
end

max = 0
max_square = 20
maxes = Array.new

# Compute powers for all squares sized s starting at x,y.
(2 .. max_square).each do |s|
  puts "square_size: %i" % s
  (1 .. grid_size-s).each do |y|
    (1 .. grid_size-s).each do |x|

      new_x = s-1 + x
      new_y = s-1 + y

      cell = (x .. new_x).map { |nx| (y .. new_y).map { |ny| grid[ [nx,ny] ] } }.flatten.sum

      if cell > max
        max = cell
        maxes = [x,y,s,max]
      end

    end
  end
end

p maxes