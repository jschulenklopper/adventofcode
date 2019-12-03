wires = Array.new

ARGF.each_line do |line|
  directions = line.strip.split(",")
  wires << directions
end

positions = Array.new

def distance(position)
  position[0].abs + position[1].abs
end

wires.each do |directions|
  list = Array.new

  position = [0,0]
  directions.each do |direction|
    dir = direction[0]
    dis = direction[1,direction.length-1].to_i

    case dir
    when "U"
      then dis.times {
        position[1] -= 1
        position[2] = distance(position)
        list << position.dup }
    when "R"
      then dis.times {
        position[0] += 1
        position[2] = distance(position)
        list << position.dup }
    when "D"
      then dis.times {
        position[1] += 1
        position[2] = distance(position)
        list << position.dup }
    when "L"
      then dis.times {
        position[0] -= 1
        position[2] = distance(position)
        list << position.dup }
    end
  end
  positions << list
end

crossings = positions[0] & positions[1]
puts crossings.sort { |a,b| a[2] <=> b[2] }.first[2]