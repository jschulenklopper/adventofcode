require '../../aoc'

lines = read_input("2019", "1")
puts lines.map { |mass| (mass.to_i / 3).floor - 2}.sum
