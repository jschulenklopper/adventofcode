STEPS = 12523873
state = "A"
checksum = 0
positions = Hash.new(0)
position = 0

# Return state and position after making move.
def step(value, position, positions, position_delta, next_state)
  positions[position] = value
  position += position_delta
  return [next_state, position]
end

STEPS.times do 
  value = positions[position]
  p situation = [state, value]

  case situation
    when ["A", 0]
      state, position = step(1, position, positions, +1, "B")
    when ["A", 1]
      state, position = step(1, position, positions, -1, "E")
    when ["B", 0]
      state, position = step(1, position, positions, +1, "C")
    when ["B", 1]
      state, position = step(1, position, positions, +1, "F")
    when ["C", 0]
      state, position = step(1, position, positions, -1, "D")
    when ["C", 1]
      state, position = step(0, position, positions, +1, "B")
    when ["D", 0]
      state, position = step(1, position, positions, +1, "E")
    when ["D", 1]
      state, position = step(0, position, positions, -1, "C")
    when ["E", 0]
      state, position = step(1, position, positions, -1, "A")
    when ["E", 1]
      state, position = step(0, position, positions, +1, "D")
    when ["F", 0]
      state, position = step(1, position, positions, +1, "A")
    when ["F", 1]
      state, position = step(1, position, positions, +1, "C")
  end
  puts positions.values.reduce(:+)
end

puts positions.values.reduce(:+)
