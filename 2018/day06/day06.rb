# Create hash for all locations.
locations = Hash.new

id = "A"  # Just give first location an id.
while line = gets
    # TODO Keeping/using the id isn't really necessary; remove that.
    locations[id] = line.match(/^(\d+), (\d+)$/).captures.map(&:to_i)
    id.next!  # Advance id to next character ("B" will be second).
end

# Find locations most to the left, top, right and bottom.
# TODO That final [1][0] is ugly; fix that.
left_x = locations.min_by { |id, loc| loc[0] }[1][0]
top_y = locations.min_by { |id, loc| loc[1] }[1][1]
right_x = locations.max_by { |id, loc| loc[0] }[1][0]
bottom_y = locations.max_by { |id, loc| loc[1] }[1][1]

# Create hash to store areas belonging to each location.
areas = Hash.new { |hash, key| hash[key] = [] }  # Assign a default value.

# Walk the grid between extremes.
(left_x .. right_x).each do |x|
    (top_y .. bottom_y).each do |y|
        # Compute all the distances between position and all locations.
        distances = Hash.new
        locations.each do |id, pos|
            # Compute Manhattan distance between two positions.
            # TODO Instead of id, pos could also work as id.
            distances[id] = (pos[0] - x).abs + (pos[1] - y).abs
        end

        # Find the closest location.
        closest = distances.min_by { |_, dis| dis }

        # Find if there are more locations just as close; those don't count.
        # (It's not strictly necessary, but it's in the puzzle description.)
        number_closest = distances.count { |id, dis| dis == closest[1] }
        # If there's only one, add position to correct location area list.
        if number_closest == 1
            # TODO Instead of closest[0], use pos.
            areas[closest[0]] << [x,y]
        end
    end
end

# From the areas, remove all the locations of which one of its positions
# are on the border of the grid; their areas are infinitely large.
areas.reject! do |_, positions|
    positions.any? { |x,y| x == left_x || x == right_x ||
                           y == top_y  || y == bottom_y }
end

# For all the areas, compute the size; the number of locations in array,
# and print the size of the largest.
puts areas.map { |_, area| area.length }.max