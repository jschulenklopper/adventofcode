position = [0, 0]  # Starting position.
orientation = 0 # North is 0, East is 1, South is 2, West is 3.
visited = [] # Array of locations visited before.
second_time = nil

instructions = gets.strip.split(", ")

instructions.each do | instruction |
  turn, distance = instruction[0], instruction[1..-1].to_i
  turn == "R" ? orientation += 1 : orientation += -1

  while distance > 0
    case orientation % 4
      when 0 then position[1] += 1 # Move North.
      when 1 then position[0] += 1 # Move East.
      when 2 then position[1] -= 1 # South.
      when 3 then position[0] -= 1 # West
    end

    if visited.include?(position) and second_time == nil
      second_time = position.dup
    end

    visited << position.dup
    distance -= 1
  end
end

puts "Final distance: %s" % [position[0].abs + position[1].abs]
puts "First location visited twice: %d" % [second_time[0].abs + second_time[1].abs]