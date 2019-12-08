# Read list of orbiting objects.
orbits = ARGF.readlines.map { |line| line.strip.split(")") }

# Generate list of all paths in orbits.
def paths(orbits, from)
  paths = [[from]]
  children = orbits.select { |o| o[0] == from }.map { |o| o[1] }

  children.each do |c|
    paths(orbits, c).each do |p|
      paths << [from] + [p]
    end
  end
  paths
end

# Generate all paths.
all_paths = paths(orbits, "COM").map { |p| p.flatten }

# Compute the paths from root to "YOU" and "SAN".
path_to_YOU = all_paths.find { |p| p.last == "YOU" }
path_to_SAN = all_paths.find { |p| p.last == "SAN" }

# Find index of common ancestor.
index = 0
until path_to_SAN[index] != path_to_YOU[index]
  index += 1
end
  
# Hops to make is number of hops from YOU and SAN to common ancestor.
puts (path_to_YOU.length - index - 1) + (path_to_SAN.length - index - 1)
