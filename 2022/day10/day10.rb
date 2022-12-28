# FIXME There's some off-by-one error somewhere here.

program = ARGF.readlines
              .map(&:split)
              .map { |i, v| [i, v.to_i] }

x = 1
cycle = 0

signals = []

program.map do | instruction, value |
  signals << x
  if instruction == "addx"
    signals << x # Hack: `addx` takes two cycles before `x` increases.
    x += value
  end
end

puts "part 1"

puts signals.map.with_index { |s, i|
  # Cycle number is i+1.
  if (i+1 + 20) % 40 == 0
    s * (i+1)
  end
}.compact.sum

puts "part 2"

row = ""
signals.each.with_index { |s, i|
  row += "\n" if i % 40 == 0 && i > 0
  cycle = i % 40 + 1
  row += cycle.between?(s, s+2) ? "#" : "."
}

puts row
