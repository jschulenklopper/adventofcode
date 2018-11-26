class Deer
  attr_accessor :name, :fly_speed, :fly_time, :rest_time
  attr_accessor :points
  attr_reader :distance

  def initialize(string)
    name, fly_speed, fly_time, rest_time = /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./.match(string)[1..4]
    @name = name
    @fly_speed = fly_speed.to_i
    @fly_time = fly_time.to_i
    @rest_time = rest_time.to_i
    @points = 0
  end

  def to_s
    "%s: fly %s km/s for %s, rest %s" % [@name, @fly_speed, @fly_time, @rest_time]
  end

  def reset_distance
    @distance = 0
  end

  def travel(time)
    @distance = distance_covered(time)
  end

  def distance_covered(time)
    distance = 0
    while time > 0
      # Fly
      flight_time = [@fly_time, time].min
      distance += flight_time * fly_speed
      time -= flight_time
      # Rest
      time -= rest_time
    end
    distance
  end
end

class Deers < Array
  def most_points
    self.max { |a, b| a.points <=> b.points }
  end

  def find_farthest
    # First, find maximum distance.
    max_distance = self.max { |a, b| a.distance <=> b.distance }.distance
    # Find deer(s) with this distance travelled.
    self.select { | d | d.distance == max_distance }
  end
end

deadline = 2503

deers = Deers.new

while line = gets
  deers << Deer.new(line)
end

# For each times from 1 sec. to deadline, compute
# the distance each deer can cover.
(1..deadline).each do | duration |
  deers.each do | deer |
    deer.reset_distance
    deer.travel(duration)
  end
  # Find deers with farthest distance.
  farthest = deers.find_farthest
  # Award point(s).
  farthest.each do | deer |
    deer.points += 1
  end
end

# Find deer with max points
puts deers.most_points.points