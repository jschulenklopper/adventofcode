$departure = ARGF.readline.to_i
buses = ARGF.readline.split(",").map(&:to_i)
$buses = buses.map.with_index { |id, i| [i, id] if id != 0 }.compact

puts "part 1"

# Find wait times for all the buses from departure time.
wait_times = $buses.map { |i, id| [ i, id, -$departure % id ] }
# Find the lowest wait time (the third entry in wait_times).
shortest = wait_times.sort { |a,b| a[2] <=> b[2]}.first

# Multiple lowest wait time with bus ID.
puts shortest[1] * shortest[2]

puts "part 2"

class Array
  def lcm
    self.reduce(1, :lcm)
  end
end

# Compute next departure after t of bus with id at index.
# TODO Fix this since $buses has a different structure now.
def next_depart(t, index, id)
  (id == 0) ? 0 : (t + index) % id
end

puts $buses.to_s
# TODO Make list of (index, id) pairs. That saves handling the irrelevant buses.
p $buses.map.with_index { |id, i| [i, id] if id != 0 }.compact

t = 0
step = 1

loop do
  puts "\nt: %i" % t
  puts "step: %i" % step

  # Compute departure times for all buses from time t.
  departures = $buses.map.with_index { |id, i|
    next_depart(t, i, id)
  }
  puts "departures: %s" % departures.to_s

  # We're done if all departures are 0.
  break if departures.all?(0)

  t += step
end
puts t

