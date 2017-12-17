Input = 337
Reps = 50000000

# Start array with first value. Second value will be updated later.
numbers = [0]
length = 1
current = 0

Reps.times do |i|
  # Move current position.
  current += Input
  current = current % length

  # Update second position if current is at start.
  if current == 0
    numbers[1] = i+1
  end

  # Adjust counters.
  length += 1
  current += 1
  current = current % length
end

# Print second position.
puts numbers[1]
