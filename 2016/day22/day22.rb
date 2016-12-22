# nodes = Array.new { |r| r = Array.new }
nodes = Hash.new

# Read all the node data
while line = gets
  # line.match(/\/dev\/grid\/node-x(?<x>\d+)-y(?<y>\d+)\s+(?<size>\d+)T\s+(?<used>\d+)T\s+(?<avail>\d+)T\s+(?<use>\d+)%/) do |match|
  line.match(/\/dev\/grid\/(?<name>node-x(?<x>\d+)-y(?<y>\d+))\s+(?<size>\d+)T\s+(?<used>\d+)T\s+(?<avail>\d+)T\s+(?<use>\d+)%/) do |match|
    name = match[:name]
    x = match[:x].to_i
    y = match[:y].to_i
    node = nodes[[x,y]] = Hash.new
    node[:name] = match[:name]
    node[:size] = match[:size].to_i
    node[:used] = match[:used].to_i
    node[:avail] = match[:avail].to_i
    node[:use] = match[:use].to_i
  end
end

nodes.each { |node| puts node.to_s }

pairs = nodes.keys.combination(2).to_a + nodes.keys.combination(2).map(&:reverse)

viable_pairs = pairs.select { |a,b|
  if a != b && nodes[a][:used] != 0 && nodes[a][:used] <= nodes[b][:avail]
    true
  else
    false
  end
}

puts viable_pairs.length
