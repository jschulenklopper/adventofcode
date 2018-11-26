class Route
  attr_accessor :from, :to, :distance

  def initialize(line)
    @from, @to, @distance = /(\w+) to (\w+) = (\d+)/.match(line)[1..3]
  end

  def to_s
    "%s -> %s: %d" % [@from, @to, @distance]
  end
end

class Routes < Array
  def distance(from, to)
    route = self.find { |r|
      r.from == from && r.to == to || r.from == to && r.to == from
    }
    route.distance.to_i
  end
end

class Cities < Array
end

routes = Routes.new
cities = Cities.new

while line = gets
  route = Route.new(line)
  routes << route
  cities << route.from if ! cities.include?(route.from)
  cities << route.to if ! cities.include?(route.to)
end

possible_trips = cities.permutation.to_a

shortest_distance = nil
possible_trips.each do |trip|
  distance = 0
  from = trip.pop
  while to = trip.pop 
    distance += routes.distance(from, to) 
    from = to
  end
  shortest_distance = distance if shortest_distance == nil || distance < shortest_distance
end

puts shortest_distance