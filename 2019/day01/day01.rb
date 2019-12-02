def fuel_needed(mass)
  fuel = (mass.to_i / 3).floor - 2
end

lines = ARGF.readlines

puts lines.map { |mass| fuel_needed(mass) }.sum