connections = ARGF.readlines.map(&:strip).map { |line| line.split("-") }

def downcase?(cave)
  cave.downcase == cave
end

def valid?(path, allowed_small_caves)
  # Path is false if `start` or `end` occur more than once.
  return false if path.count("start") > 1
  return false if path.count("end") > 1

  # Path is false if two or more small cave occur more than once.
  return false if path.filter { |p| downcase?(p) }.tally.values.count(2) > allowed_small_caves

  # Path is false if a small cave occurs.
  return false if path.filter { |p| downcase?(p) }.tally.values.count { |v| v >= 3 } > 0

  true
end

def paths(start, goal, prefix, map, allowed_small_caves, &block)
  if start == goal
    yield prefix + [goal]
  end

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
    map[from] << to
    map[to] << from
  end
  map
end

puts "part 1"
paths = []
paths("start", "end", [ ], map(connections), 0) { |path| paths << path }
puts paths.length

puts "part 2"
paths = []
paths("start", "end", [ ], map(connections), 1) { |path| paths << path }
puts paths.length
