constellations = Hash.new { |hash, key| hash[key] = Array.new }
stars = Array.new
id = "a"  # First id for constellation; use `#next` for `b` and so on.

Star = Struct.new(:x, :y, :z, :t)

def in_same_constellation?(star, other_star)
  ((star.x - other_star.x).abs + (star.y - other_star.y).abs + 
   (star.z - other_star.z).abs + (star.t - other_star.t).abs) <= 3
end

# Read input.
while line = gets
  x, y, z, t = line.split(",").map(&:to_i)
  stars << Star.new(x, y, z, t)
end

# Find constellations, one pass over stars, searching in all constellations.
stars.each do |star|
  in_constellations = []

  constellations.each do |id, stars_in_constellation|
    stars_in_constellation.each do |s|
      # Test if star is in same constellation
      if in_same_constellation?(star, s)
        in_constellations << id
        break
      end
    end
  end

  unless in_constellations.length > 0
    # Create new constellation.
    in_constellations << id
    id = id.next
  end

  # Merge constellations if star is in more than one.
  main_constellation = in_constellations.shift  # Take one as main.
  # Add star to existing constellation.
  constellations[main_constellation] << star
  in_constellations.each do |id|                # Process remaining ones.
    # Add stars to main constellation.
    constellations[main_constellation] += constellations[id]
    # Delete merged constellation.
    constellations.delete(id)                    
  end
end

puts constellations.keys.length
