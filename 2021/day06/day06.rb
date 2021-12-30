fish = ARGF.readline.split(",").map(&:to_i)

$memo = Hash.new

def yields(birth, max_day)
  return $memo["%i,%i" % [birth, max_day]] if $memo["%i,%i" % [birth, max_day]]

  # No opportunity to create more fish.
  return 1 if birth >= max_day

  # Direct descendants of fish.
  direct = yields(birth + 7, max_day)
  # ... and its indirect descendants.
  indirect = yields(birth + 9, max_day)

  # Yield direct and indirect descendants (and store in $memo).
  $memo["%i,%i" % [birth, max_day]] = direct + indirect
end

puts "part 1"
count = fish.sum do |age| 
  # Compute how many fish this one will create.
  yields(age, 80)
end
puts count

puts "part 2"
count = fish.sum do |age| 
  yields(age, 256)
end
puts count
