def fuel_needed(mass)
  fuel = (mass.to_i / 3).floor - 2
  # Increase fuel need for additional fuel needed.
  if fuel < 0 then 0 else fuel += fuel_needed(fuel) end
end

lines = ARGF.readlines

puts lines.map { |mass| fuel_needed(mass) }.sum