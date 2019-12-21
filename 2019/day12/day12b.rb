# Read positions of four moons.
positions = ARGF.readlines

DIMENSIONS = [:x, :y, :z, :vx, :vy, :vz]

Moon = Struct.new(:x, :y, :z, :vx, :vy, :vz) do 
  def apply_gravity(other)
    if self.x < other.x then self.vx += 1; other.vx -= 1
    elsif self.x > other.x then self.vx -= 1; other.vx += 1 end

    if self.y < other.y then self.vy += 1; other.vy -= 1
    elsif self.y > other.y then self.vy -= 1; other.vy += 1 end

    if self.z < other.z then self.vz += 1; other.vz -= 1
    elsif self.z > other.z then self.vz -= 1; other.vz += 1 end
  end

  def apply_velocity
    self.x += vx; self.y += vy; self.z += vz
  end
end

moons = Array.new

positions.each do |line|
  x, y, z = line.match(/\<x=([\-0-9]+), y=([\-0-9]+), z=([\-0-9]+)\>/).captures.map(&:to_i)
  moons << Moon.new(x, y, z, 0, 0, 0)
end

# Array of moons' starting dimensions.
loop_starts = Hash.new(6)
# Length of loops... once found.
loop_found = Hash.new { |hash, key| hash[key] = nil }

steps = 0

# Store current moons' dimensions from start.
DIMENSIONS.map do |dim|
  loop_starts[dim] = moons.map { |moon| moon.send(dim) }
end

while loop_found.length < DIMENSIONS.length
  moons.combination(2).each do |one, two| one.apply_gravity(two) end
  moons.each do |moon| moon.apply_velocity end

  steps += 1
  
  # Check whether moons' dimensions have been seen before.
  loop_now = Hash.new
  DIMENSIONS.map do |dim|
    loop_now[dim] = moons.map { |moon| moon.send(dim) }
  end

  DIMENSIONS.select { |d| d.to_s.length == 1}.each do |dim|
    # Get corresponding velocity key.
    vdim = ("v" + dim.to_s).to_sym 

    # Store number of steps for dimension to loop.
    if loop_now[dim] == loop_starts[dim] &&
         loop_now[vdim] == loop_starts[vdim]
      loop_found[dim] ||= steps
      loop_found[vdim] ||= steps
    end
  end
end

# The first time the moons are at identical positions
# is at the Lowest Common Multiple of the cycle times.
puts loop_found.values.reduce(1, :lcm)