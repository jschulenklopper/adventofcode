Bot = Struct.new(:x, :y, :z, :r)
bots = []

def distance(from, to)
  (from.x - to.x).abs + (from.y - to.y).abs + (from.z - to.z).abs
end

while line = gets
  x, y, z, r = line.match(/(\-?\d+),(\-?\d+),(\-?\d+).*=(\d+)/).captures.map(&:to_i)

  bots << Bot.new(x, y, z, r)
end

strongest = bots.sort_by { |b| b.r }.last

puts bots.select { |b| distance(b, strongest) <= strongest.r }.count