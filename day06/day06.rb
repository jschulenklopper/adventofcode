def turn_on(local_grid, from, to)
  (from[0]..to[0]).each do |x|
    (from[1]..to[1]).each do |y|
      local_grid[[x,y]] = 1
    end
  end
end

def turn_off(local_grid, from, to)
  (from[0]..to[0]).each do |x|
    (from[1]..to[1]).each do |y|
      local_grid[[x,y]] = 0
    end
  end
end

def toggle(local_grid, from, to)
  (from[0]..to[0]).each do |x|
    (from[1]..to[1]).each do |y|
      local_grid[[x,y]] = (local_grid[[x,y]] == 0) ? 1 : 0
    end
  end
end

grid = Hash.new(0)

while line = gets
  instruction = /^(toggle|turn on|turn off)/.match(line.strip)[1]
  from = /^[a-z ]*(\d+),(\d+)/.match(line.strip)
  from_x, from_y = from[1], from[2]
  to = /through (\d+),(\d+)$/.match(line.strip)
  to_x, to_y = to[1], to[2]

  case instruction
    when "turn on"
      turn_on(grid, [from_x, from_y], [to_x, to_y])
    when "turn off"
      turn_off(grid, [from_x, from_y], [to_x, to_y])
    when "toggle"
      toggle(grid, [from_x, from_y], [to_x, to_y])
  end
end

puts grid.delete_if {|k, v| v == 0}.length

