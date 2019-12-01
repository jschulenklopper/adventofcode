require '../../aoc'

lines = read_input("2019", "1")

def fuel_needed(mass)
  fuel = (mass.to_i / 3).floor - 2
  return 0 if fuel < 0
  return fuel += fuel_needed(fuel)
end

fuel_needs = lines.map do |mass|
  total = 0
  # Calculate fuel need to module mass.
  total += fuel = fuel_needed(mass)
end

puts fuel_needs.sum