depart = ARGF.readline.to_i
buses = ARGF.readline.split(",").map(&:to_i)

puts "part 1"
waits = buses.map { |id| id == 0 ? nil : -(depart % id) + id}
shortest = waits.reject { |w| w == nil }.min

index = waits.find_index(shortest)
puts buses[index] * waits[index]
