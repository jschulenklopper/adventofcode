commands = ARGF.readlines.map { |line| line.match(/(.+) (.+)/).captures }
                         .map { |direction, units| [direction, units.to_i] }

position, depth = 0, 0

commands.each do | direction, units |
  case direction
    when "forward" then position += units
    when "down" then depth += units
    when "up" then depth -= units
  end
end

puts "part 1"
puts position * depth

position, depth, aim = 0, 0, 0

commands.each do | direction, units |
  case direction
    when "forward"
      position += units
      depth += aim * units
    when "down" then aim += units
    when "up" then aim -= units
  end
end

puts "part 2"
puts position * depth
