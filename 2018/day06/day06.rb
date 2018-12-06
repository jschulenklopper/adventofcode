re_line = /^(\d+), (\d+)$/

locations = Hash.new
id = "A"  # Just give first location an id.

while line = gets
    x, y = line.strip.match(re_line).captures.map(&:to_i)
    locations[id] = [x,y]

    id.next!
end

def distance(a, b)
    (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

most_left = locations.min_by { |loc| loc[1][0] }
most_top = locations.min_by { |loc| loc[1][1] }
most_right = locations.max_by { |loc| loc[1][0] }
most_bottom = locations.max_by { |loc| loc[1][1] }

areas = Hash.new { |hash, key| hash[key] = [] }

(most_left.last[0] .. most_right.last[0]).each do |x|
    (most_top.last[1] .. most_bottom.last[1]).each do |y|
        distances = Hash.new
        locations.each do |id, pos|
          distances[id] = distance(pos, [x,y])
        end

        closest = distances.min_by { |dis| dis[1]}
        number_closest = distances.count { |dis| dis[1] == closest[1] }

        if number_closest == 1
           areas[closest[0]] << [x,y]
        end
    end
end

areas.reject! do |id, positions|
    positions.count { |x,y| x == most_left[1][0] || x == most_right[1][0] ||
                            y == most_top[1][1]  || y == most_bottom[1][1] } >= 1
end

sizes = areas.map { |key, value| [key, value.length] }
p sizes.max_by { |item| item[1]}[1]
