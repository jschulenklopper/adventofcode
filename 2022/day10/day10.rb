# FIXME There's some off-by-one error somewhere here.

program = ARGF.readlines
              .map(&:split)
              .map { |i, v| [i, v.to_i] }

x = 1
cycle = 0

signals = [x]

program.map do | instruction, value |
  signals << x
  if instruction == "addx"
    signals << x # Dirty hack: `addx` takes two cycles before `x` increases.
    x += value
  end
end

puts "part 1"

puts signals.map.with_index { |s, i|
  if (i + 20) % 40 == 0
    s * i
  end
}.compact.sum

puts "part 2"

row = []
signals.each.with_index { |s, i|
  cycle = i % 40
  row[cycle] = cycle.between?(s, s+2) ? "#" : "."

  if cycle == 0
    puts row.join
    row = []
  end
}
