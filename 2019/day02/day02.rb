lines = ARGF.readlines

line = lines.first

# Read instructions into positions.
positions = line.strip.split(",").map(&:to_i)

current = 0

# Replace position[1] with 12, position[2] with 2.
positions[1] = 12
positions[2] = 2

while true do
  case positions[current]
  when 1 then
    new_value = positions[positions[current + 1]] + positions[positions[current + 2]]
    positions[positions[current + 3]] = new_value
  when 2 then
    new_value = positions[positions[current + 1]] * positions[positions[current + 2]]
    positions[positions[current + 3]] = new_value
  when 99 then
    break
  end

  current += 4
end

puts positions[0]