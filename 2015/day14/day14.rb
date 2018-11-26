class Deer
  attr_accessor :name, :fly_speed, :fly_time, :rest_time

  def initialize(string)
    name, fly_speed, fly_time, rest_time = /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./.match(string)[1..4]
    @name = name
    @fly_speed = fly_speed.to_i
    @fly_time = fly_time.to_i
    @rest_time = rest_time.to_i
  end

  def to_s
    "%s: fly %s km/s for %s, rest %s" % [@name, @fly_speed, @fly_time, @rest_time]
  end

  def distance(time)
    distance = 0
    while time > 0
      # fly
      flight_time = [@fly_time, time].min
      distance += flight_time * fly_speed
      time -= flight_time
      # rest
      time -= rest_time
    end
    distance
  end

end

deadline = 2503

deers = Array.new

while line = gets
  deers << Deer.new(line)
end

max_distance = 0
deers.each do |deer|
  distance = deer.distance(deadline)
  max_distance = distance if distance > max_distance
end

puts max_distance