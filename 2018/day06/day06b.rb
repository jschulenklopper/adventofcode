re_line = /^(\d+), (\d+)$/

locations = Hash.new
id = "A"

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

margin = 1
CAP = 10000

area = []

(most_left.last[0] - margin .. most_right.last[0] + margin).each do |x|
    (most_top.last[1] - margin .. most_bottom.last[1] + margin).each do |y|
        distances = Hash.new

        locations.each do |id, pos|
          distances[id] = distance(pos, [x,y])
        end

        total_distance = distances.reduce(0) { |memo, value|
          memo += value[1]
        }

        if total_distance < CAP
            area << [[x,y]]
        end


    end
end

puts area.length