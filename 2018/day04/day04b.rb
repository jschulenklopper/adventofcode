# Input lines are being sorted (conveniently by date/time, at the start).
lines = gets(nil).split("\n").sort

# Maintain a list of guards, and keep track of the current one.
guards = Hash.new()
current_guard = 0

lines.each do |line|
    # Capturing year, month, day, hour, minute to action array.
    action = line.match(/^\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\]/).captures.map(&:to_i)
    # Make the start happen on the first minute of midnight.
    start = (action[3] != 0) ? 0 : action[4]
    
    if line.match(/wakes up/)
        # Mark punch card as awake, decreasing sleep count from start to end.
        (start..59).each { |m| guards[current_guard][m] += -1 }
    elsif line.match(/falls asleep/)
        # Mark punch card as being sleep from start to end.
        (start..59).each { |m| guards[current_guard][m] += 1 }
    elsif guard = line.match(/Guard #(\d+) begins shift/).captures.map(&:to_i).first
        # New guard begins shift.
        current_guard = guard
        # Create a new punch card for the new guard, fill it with zeros.
        guards[current_guard] = Array.new(60,0) unless guards[current_guard]
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