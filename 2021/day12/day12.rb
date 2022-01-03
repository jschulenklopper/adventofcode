connections = ARGF.readlines.map(&:strip).map { |line| line.split("-") }

def valid?(path, allowed_small_caves)
  # Path is false if `start` or `end` occur more than once.
  return false if path.count("start") > 1 || path.count("end") > 1

  # Path is false if two or more small caves occur more than once.
  return false if path.filter { |p| p.downcase == p }.tally.values.count(2) > allowed_small_caves

  # Path is false if a small cave occurs.
  return false if path.filter { |p| p.downcase == p }.tally.values.count { |v| v >= 3 } > 0

  # No problem found in path.
  true
end

def paths(start, goal, prefix, map, allowed_small_caves, &block)
  yield prefix + [goal] if start == goal

  # Figure out next steps from `start`, take into account earlier nodes.
  steps = map[start].filter do |cave|
    valid?([start] + prefix + [cave], allowed_small_caves)
  end

  # Make step and (try to) generate paths.
  steps.each do |step|
    paths(step, goal, prefix + [start], map, allowed_small_caves, &block)
  end
end

def map(connections)
  map = Hash.new { |hash, key| hash[key] = [] }
  connections.each do |from,to|
    map[from] << to; map[to] << from
  end
  map
end

puts "part 1"
count = 0 
paths("start", "end", [ ], map(connections), 0) { |_| count += 1 }
puts count

puts "part 2"
count = 0 
paths("start", "end", [ ], map(connections), 1) { |_| count += 1 }
puts count
