# Read positions of four moons.
positions = ARGF.readlines

# Moon = Struct.new(:position, :velocity)
Moon = Struct.new(:x, :y, :z, :vx, :vy, :vz) do 
  def name
    "%s " % self.__id__.to_s[-3,3]
  end

  def to_s
    "%s -> %2i, %2i, %2i  (%2i, %2i, %2i)" % [self.__id__.to_s[-3,3], x, y, z, vx, vy, vz]
  end

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

  def total_energy
    potential_energy * kinetic_energy
  end

  def potential_energy
    x.abs + y.abs + z.abs
  end

  def kinetic_energy
    vx.abs + vy.abs + vz.abs
  end
end

moons = Array.new

positions.each do |line|
  x, y, z = line.match(/\<x=([\-0-9]+), y=([\-0-9]+), z=([\-0-9]+)\>/).captures.map(&:to_i)
  moons << Moon.new(x, y, z, 0, 0, 0)
end

STEPS = 1000

STEPS.times do |i|
  # moons.each do |moon| puts moon end

  moons.combination(2).each do |one, two| one.apply_gravity(two) end

  moons.each do |moon| moon.apply_velocity end
end

puts moons.sum(&:total_energy)