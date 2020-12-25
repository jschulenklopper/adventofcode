$cups = ARGF.readline.strip.chars.map(&:to_i)

def one_move(circle, current, lowest, highest)
  # Pick up three cups, remove (bypass) from circle.
  pick_up = [ circle[current], circle[circle[current]], circle[circle[circle[current]]] ]
  circle[current] = circle[pick_up.last]

  # Select destination cup.
  destination = (current <= lowest) ? highest : current - 1
  while pick_up.include?(destination)
    destination = (destination <= lowest) ? highest : destination - 1
  end

  # Place picked up cups after destination.
  circle[pick_up[2]] = circle[destination]
  circle[destination] = pick_up[0]

  # Select new current cup: next cup clockwise.
  current = circle[current]

  [circle, current]
end

puts "part 1"

# Circle of numbers as key, and next number as value.
circle = {}
$cups.each.with_index { |c,i| circle[c] = $cups[(i+1) % $cups.length]  }
lowest, highest = $cups.min, $cups.max

# Current number.
current = $cups[0]

100.times do |i|
  circle, current = one_move(circle, current, lowest, highest)
end

start = 1
puts (circle.length-1).times.map { |str, _| str += start; start = circle[start] }.join

puts "part 2"

# Build circle from inital cups, and extend to 1000000.
circle = {}
($cups.max+1 .. 1000000).each { |cup| $cups << cup }
$cups.each.with_index { |c,i| circle[c] = $cups[(i+1) % $cups.length]  }
lowest, highest = $cups.min, $cups.max

# Current number.
current = $cups[0]

10000000.times do |i|
  circle, current = one_move(circle, current, lowest, highest)
end

puts circle[1] * circle[circle[1]]
