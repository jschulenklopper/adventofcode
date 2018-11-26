Input = gets.strip.to_i
Reps = 2017

numbers = [0]
current = 0

Reps.times do |i|
  # Move current position.
  current += Input
  current = current % numbers.length

  # Insert number _after_ that position.
  numbers.insert(current + 1, i+1)

  # Move current index to that position.
  current += 1
  current = current % numbers.length
end
  
puts numbers[current+1]