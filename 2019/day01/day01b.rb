require '../../aoc'

lines = read_input("2019", "1")

def fuel_needed(mass)
  (mass.to_i / 3).floor - 2
end

fuel_needs = lines.map do |mass|
  total = 0
  # Calculate fuel need to module mass.
  total += fuel = fuel_needed(mass)
  # Calculate fuel need for fuel mass.
  until fuel <= 0
    fuel = fuel_needed(fuel)
    total += fuel if fuel >= 0
  end
  total
end

puts fuel_needs.sum