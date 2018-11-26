Directions = {:N => [-1,0], :S => [1,0], :W => [0,-1], :E => [0,1] }
BURSTS = 10_000_000

def turn(direction, turn)
  if turn == :left
    case direction; when :N; :W; when :S; :E; when :W; :S; when :E; :N; end
  elsif turn == :right
    case direction; when :N; :E; when :S; :W; when :W; :N; when :E; :S; end
  elsif turn == :back
    case direction; when :N; :S; when :S; :N; when :W; :E; when :E; :W; end
  else
    direction
  end
end

def move(position, direction)
  # This doesn't look pretty... but haven't found another way yet.
  position[0] += Directions[direction][0]
  position[1] += Directions[direction][1]
  position
end

def main(file)
  grid = Hash.new(".")

  lines = File.open(file).readlines.map(&:chomp)
  height = lines.length
  width = lines[0].length

  lines.each_with_index { |row, i|
    r = i - (height-1)/2
    row.chars.each_with_index { |col, j|
      c = j - (width-1)/2
      grid[[r,c].to_s] = col  # There could be a better way...
    }
  }

  position = [0,0]
  direction = :N
  infections = 0

  BURSTS.times do
    if grid[ position.to_s ] == "."
      # We are on a clean node, so turn left and weaken node.
      direction = turn(direction, :left)
      grid[ position.to_s ] = "W"
    elsif grid[ position.to_s ] == "W"
      # We are on a weakened node, so do not turn and infect node.
      grid[ position.to_s ] = "#"
      infections += 1
    elsif grid[ position.to_s ] == "F"
      # We are on a flagged node, so reverse direction and clean node.
      direction = turn(direction, :back)
      grid[ position.to_s ] = "."
    else
      # We're on an infected node, so turn right and flag node.
      direction = turn(direction, :right)
      grid[ position.to_s ] = "F"
    end
    # Move to new position.
    position = move(position, direction) 
  end

  infections
end

if __FILE__ == $0
  puts main(ARGV[0])
end