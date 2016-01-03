def merge_arrays(hash1, hash2)
  new_hash = hash1.clone
  hash2.each do |k,v|
    if new_hash.has_key?(k)
      new_hash[k] += v
    else
      new_hash[k] = v
    end
  end
  new_hash
end

def valid?(filled_compartments, max)
  filled_compartments.each do |compartment, packages|
    return false if packages.reduce(:+) > max
  end
  return true
end

def equal_weight?(filled_compartments)
  weights = Array.new
  filled_compartments.each do |compartment, packages|
    weights << packages.reduce(:+)
  end
  # Use a trick with uniq to determine whether numbers are equal.
  return weights.uniq.length == 1
end

def divide(packages, compartments, max)
  if packages.length == 0 then yield ({}); return end

  package = packages.first

  compartments.each do |compartment|
    first = {compartment => [package]}
    divide(packages - [package], compartments, max) do |rest|
      merged = merge_arrays(first, rest)
      if valid?(merged, max)
        yield merged
      end
    end
  end
end

packages = []

while package = gets do packages << package.strip.to_i end

max_per_compartment = (packages.reduce(:+) / 3).ceil

valid_fillings = Array.new
least_packages_in_front = nil

# Divide packages over three compartments: F(ront), L(eft) and R(ight)
divide(packages, ["R", "L", "F"], max_per_compartment) do |filled_compartments|
  if equal_weight?(filled_compartments)
    valid_fillings << filled_compartments

    number_of_packages_in_front = filled_compartments["F"].length
    least_packages_in_front ||= number_of_packages_in_front

    if number_of_packages_in_front < least_packages_in_front
      least_packages_in_front = number_of_packages_in_front
    end
  end
end

# Skip fillings with too much packages_in_front.
optimal_fillings = valid_fillings.select do |filling|
  filling["F"].length == least_packages_in_front
end

# Compute QE for the remaining fillings.
qe_fillings = optimal_fillings.map do |filling|
  filling["QE"] = filling["F"].reduce(:*) 
  filling
end

# Find smallest QE.
puts qe_fillings.map { |filling| filling["QE"]}.min
