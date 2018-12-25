constellations = Hash.new { |hash, key| hash[key] = Array.new }
stars = Array.new
id = "a"  # First id for constellation, just for fun.

Star = Struct.new(:x, :y, :z, :t)

def in_same_constellation?(star, other_star)
  ((star.x - other_star.x).abs + (star.y - other_star.y).abs + 
   (star.z - other_star.z).abs + (star.t - other_star.t).abs) <= 3
end

# Read input.
while line = gets
  break if line.strip.empty?

  x, y, z, t = line.split(",").map(&:to_i)
  stars << Star.new(x, y, z, t)
end

# Find constellations, one pass over stars, searching in all constellations.
stars.each do |star|
  in_constellations = []

  constellations.each do |id, stars_in_constellation|
    stars_in_constellation.dup.each do |s|  # NB The `#dup` here, to prevent looping over growing collection.
      # Test if star is in same constellation, and not added before. # TODO Fix that ugly second condition.
      if in_same_constellation?(star, s) && !constellations[id].include?(star)
        # Add star to existing constellation.
        constellations[id] << star
        in_constellations << id
      end
    end
  end

  unless in_constellations.length > 0
    # Create new constellation.
    constellations[id] = [star]
    id = id.next
  end

  # Merge constellations if star is also in other one.
  main_constellation = in_constellations.shift  # Take first constellation as main.
  in_constellations.dup.each do |id|            # Process remaining ones.
    constellations[id].each do |star|
      constellations[main_constellation] << star  # Ad star to main constellation.
    end
    constellations.delete(id)  # Delete merged constellation.
  end
end

puts constellations.keys.length