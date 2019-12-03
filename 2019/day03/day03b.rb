wires = Array.new

ARGF.each_line do |line|
  directions = line.strip.split(",").map { |step| [step[0], step[1..step.length-1].to_i] }
  wires << directions
end

positions = Array.new

wires.each do |directions|
  pos = Array.new

  position = [0,0,0]  # X, Y, number of steps

  directions.each do |dir, dis|
    case dir
    when "U"
      then dis.times {
        position[1] -= 1
        position[2] += 1
        pos << position.dup }
    when "R"
      then dis.times {
        position[0] += 1
        position[2] += 1
        pos << position.dup }
    when "D"
      then dis.times {
        position[1] += 1
        position[2] += 1
        pos << position.dup }
    when "L"
      then dis.times {
        position[0] -= 1
        position[2] += 1
        pos << position.dup }
    end
  end
  positions << pos
end

# Calculate crossings by a set union of X,Y positions of both wires.
crossings = positions[0].map { |p| p[0,2] } & positions[1].map { |p| p[0,2] }

# Get commulative distance of both wires to each crossing.
distances = crossings.map { |c| positions[0].find { |p| p[0] == c[0] && p[1] == c[1] }[2] +
                                positions[1].find { |p| p[0] == c[0] && p[1] == c[1] }[2] }

puts distances.min