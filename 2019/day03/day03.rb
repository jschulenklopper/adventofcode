wires = Array.new

ARGF.each_line do |line|
  directions = line.strip.split(",").map { |step| [step[0], step[1..step.length-1].to_i] }
  wires << directions
end

positions = Array.new

def distance(position)
  position[0].abs + position[1].abs
end

wires.each do |directions|
  pos = Array.new

  position = [0,0,0]  # X, Y, distance
  directions.each do |dir, dis|
    dis.times do
      case dir
        when "U" then position[1] -= 1
        when "R" then position[0] += 1
        when "D" then position[1] += 1
        when "L" then position[0] -= 1
      end
      pos << position.dup
    end
  end
  positions << pos
end

# Calculate interactions of positions of both wires.
crossings = positions[0] & positions[1]

# Sort crossings on Manhattan distance, and show distance of first.
puts distance(crossings.sort { |a,b| distance(a) <=> distance(b) }.first)