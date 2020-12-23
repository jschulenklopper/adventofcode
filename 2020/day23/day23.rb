cups = ARGF.readline.strip.chars.map(&:to_i)

current_index = 0
length = cups.length
lowest, highest = [ cups.min, cups.max ]

puts "part 1"
100.times do |i|
  label = cups[current_index]

  pick_up = (1..3).map { |i| cups[(current_index + i) % length] }
  pick_up.each { |cup| cups.delete(cup) }

  destination = label - 1
  destination = highest if destination < lowest

  # If this would select one of the cups that was just picked up,
  # the crab will keep subtracting one until it finds a cup that
  # wasn't just picked up.
  while pick_up.include?(destination)
    destination -= 1

    # If at any point in this process the value goes below the
    # lowest value on any cup's label, it wraps around to the
    # highest value on any cup's label instead.
    if destination < lowest
      destination = highest
    end
  end
  
  destination = highest if destination < lowest
  destination_index = cups.find_index(destination)
  cups.insert(destination_index + 1, pick_up[0], pick_up[1], pick_up[2])
  current_index = (cups.find_index(label) + 1) % length
end

one_at = cups.find_index(1)
puts cups.rotate(one_at)[1..-1].join
