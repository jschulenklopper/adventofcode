require '../../aoc'

def fuel_needed(mass)
  fuel = (mass.to_i / 3).floor - 2
end

lines = read_input("2019", "1")

puts lines.map { |mass| fuel_needed(mass) }.sum
