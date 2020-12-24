$cups = ARGF.readline.strip.chars.map(&:to_i)
$lowest, $highest = [ $cups.min, $cups.max ]
$length = $cups.length
cups = $cups.dup

def one_move(cups, current_index)
  label = cups[current_index]

  pick_up = (1..3).map { |i| cups[(current_index + i) % $length] }
  pick_up.each { |cup| cups.delete(cup) }

  destination = (label <= $lowest) ? $highest : label - 1

  while pick_up.include?(destination)
    destination = (destination <= $lowest) ? $highest : destination - 1 
  end
  
  destination_index = cups.find_index(destination)
  cups.insert(destination_index + 1, pick_up[0], pick_up[1], pick_up[2])
  current_index = (cups.find_index(label) + 1) % $length

  [cups, current_index]
end

puts "part 1"

current_index = 0
100.times do |i|
  cups, current_index = one_move(cups, current_index)
end

one_at = cups.find_index(1)
puts cups.rotate(one_at)[1..-1].join
