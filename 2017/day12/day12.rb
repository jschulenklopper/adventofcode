def reach(programs, id)
  reach = []

  # Process id via a breadth-first search (thus a queue).
  queue = [id]
  while node = queue.shift
    reach << node unless reach.include?(node)
    programs[node].each { |n| queue.push(n) unless reach.include?(n) }
  end

  reach
end

programs = Hash.new(Array.new)

while line = gets
  line.match(/^(?<from>\w+) \<-\> (?<to>.+)$/) do |match|
    from = match[:from].to_i
    tos = match[:to].split(", ").map(&:to_i)

    tos.each do |to|
		  programs[from] += [to] unless programs[from].include?(to)
      # Strictly, this isn't necessary, but it's according to specification.
      programs[to] += [from] unless programs[to].include?(from)
    end
   
  end
end

connected = []
programs.each { |n, _|
  # Find all the nodes to be reached from n.
  mst = reach(programs, n).sort
  # Add that list if it's a new list.
  connected.push(mst) unless connected.include?(mst)
}

puts "size of group %s: %s" % [0, connected[0].length]
puts "number of groups: %s" % connected.length
