re_line = /^(\d+), (\d+)$/  # Expression to capture X and Y coordinates.

# Create hash for all locations.
locations = Hash.new

id = "A"  # Just give first location an id.
while line = gets
    x, y = line.strip.match(re_line).captures.map(&:to_i)
    locations[id] = [x,y]
    id.next!  # Advance id to next character ("B" will be second).
end

# Compute Manhattan distance between two positions.
def distance(a, b)
    (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

# Find locations most to the left, top, right and bottom.
_, most_left_x = locations.min_by { |id, loc| loc[0] }
_, most_top_y = locations.min_by { |id, loc| loc[1] }
_, most_right_x = locations.max_by { |id, loc| loc[0] }
_, most_bottom_y = locations.max_by { |id, loc| loc[1] }

# Create hash to store areas belonging to each location.
areas = Hash.new { |hash, key| hash[key] = [] }

p most_left_x 
p most_right_x

# Walk the grid between extreme location.
(most_left_x[0] .. most_right_x[0]).each do |x|
    (most_top_y[1] .. most_bottom_y[1]).each do |y|
        # Compute all the distances between position and all locations.
        distances = Hash.new
        locations.each do |id, pos|
          distances[id] = distance(pos, [x,y])
        end

        # Find the closest location.
        closest = distances.min_by { |dis| dis[1]}

        # Find if there are more locations just as close.
        # (It's not strictly necessary, but there in the puzzle description.)
        number_closest = distances.count { |dis| dis[1] == closest[1] }
        # If there's only one, add position to correct location area list.
        if number_closest == 1
            areas[closest[0]] << [x,y]
        end
    end
end

# From the areas, remove all the locations of which one of its positions
# are on the border of the grid; their areas are infinitely large.
areas.reject! do |_, positions|
    positions.count { |x,y| x == most_left_x[0] || x == most_right_x[0] ||
                            y == most_top_y[1]  || y == most_bottom_y[1] } >= 1
end

# For all the areas, compute the size; the number of locations.
sizes = areas.map { |id, value| [id, value.length] }

# Print the size of the largest.
puts sizes.max_by { |item| item[1]}[1]