Directions = {:N => [-1,0], :S => [1,0], :W => [0,-1], :E => [0,1] }
BURSTS = 10000

def turn(direction, turn)
  if turn == :left
    case direction
      when :N
        :W
      when :S
        :E
      when :W
        :S
      when :E
        :N
    end
  else
    case direction
      when :N
        :E
      when :S
        :W
      when :W
        :N
      when :E
        :S
    end
  end
end

def print(grid, height, width, position)
  string = ""
  ( -1*(height-1)/2 .. (height-1)/2 ).each { |r|
    ( -1*(width-1)/2 .. (width-1)/2 ).each { |c|
      sep = ([r,c].to_s == position.to_s) ? "[" : " "
      string << sep + grid[ [r,c].to_s ]
    }
    string << "\n"
  }
  puts string
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
    # Are we on a clean node?
    if grid[ position.to_s ] == "."
      # Turn left.
      direction = turn(direction, :left)
      # Infect node.
      grid[ position.to_s ] = "#"
      # Increase infection counter.
      infections += 1
      # Move.
      position[0] += Directions[direction][0]
      position[1] += Directions[direction][1]
    else
      # We're on an infected node.
      # Turn right.
      direction = turn(direction, :right)
      # Clean node.
      grid[ position.to_s ] = "."
      # Move.
      position[0] += Directions[direction][0]
      position[1] += Directions[direction][1]
    end
  end

  return infections
end

if __FILE__ == $0
  puts main(ARGV[0])
end

