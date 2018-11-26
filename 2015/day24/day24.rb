packages = []

while package = gets do packages << package.strip.to_i end

# We need to distribute the load evenly over three compartments,
# so we know the exact load per compartment and the
# maximum number of one (will be the first) compartment.
load_per_compartment = (packages.reduce(:+) / 4).ceil
max_packages_per_compartment = (packages.length / 4).ceil

valid_fillings = Array.new
packages_in_front = 1

while packages_in_front <= max_packages_per_compartment
  fillings = Array.new

  # Try to find the filling with desired number of packages in front.
  valid_fillings = packages.combination(packages_in_front).select do |a|
    a.reduce(:+) == load_per_compartment
    # TODO Test assumption that rest of packages can be
    # divided in two equal-weight groups as well.
  end
  break if valid_fillings.length > 0
  packages_in_front += 1
end

qes = valid_fillings.map { |a| a.reduce(1, :*) } 

puts qes.sort.first