re_time = /^\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\]/
re_wakes = /wakes up/
re_sleeps = /falls asleep/
re_shift = /Guard #(\d+) begins shift/

actions = []

while line = gets do
    # Capturing year, month, day, hour, minute to action array.
    action = line.match(re_time).captures.map(&:to_i)
    
    # Add verb, or add guard id to action.
    if line.match(re_wakes)
        action << :wakes
    elsif line.match(re_sleeps)
        action << :sleeps
    elsif guard = line.match(re_shift).captures.map(&:to_i).first
        action << guard
    end

    actions << action
end

# Sort actions (on date and time, which are the first entries in the arrays).
actions.sort!

guards = Hash.new()
current_guard = 0

actions.each do |action|
    # Make the start happen on the first minute of midnight.
    start = (action[3] != 0) ? 0 : action[4]

    if action[5].class == Integer
        # New guard begins shift.
        current_guard = action[5]
        # Create a new punch card for the new guard, fill it with zeros.
        guards[current_guard] = Array.new(60,0) unless guards[current_guard]
    elsif action[5] == :sleeps
        # Mark punch card as being sleep from start to end.
        (start..59).each { |m| guards[current_guard][m] += 1 }
    elsif action[5] == :wakes
        # Mark punch card as awake, decreasing sleep count from start to end.
        (start..59).each { |m| guards[current_guard][m] += -1 }
    end

end

# Find the guard that is asleep the most minutes.
guard_most_asleep = guards.max_by do |g|
    # Compute minute most slept on.
    # This value will be used to find the sleepiest guard.
    # NB: guard's id is first in g.
    guards[g.first].max
end.first

# Find the most slept minute for the guard that is most sleepy.
sleepiest_minute = guards[guard_most_asleep].find_index(guards[guard_most_asleep].max)

puts guard_most_asleep * sleepiest_minute