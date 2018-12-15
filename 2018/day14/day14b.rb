target = gets.strip

# Starting recipes.
recipes = [3,7]

# Initial position of two elves.
elves = [0, 1] 

def new_recipe(recipes, elves)
  # Strangely enough, digits() returns characters in 'wrong' order.
  (recipes[elves[0]] + recipes[elves[1]]).digits.reverse
end

def new_positions(recipes, elves)
  elves.map do |position|
    position += (1 + recipes[position])
    position % recipes.length
  end
end

def find_target(target, recipes, from_index)
  if index = recipes[from_index..-1].join.index(target)
    [true, index + from_index]
  else
    [false, (recipes.length - 10 > 0 ) ? recipes.length - 10 : 0]
  end
end

# Start searching from this index.
from_index = 0

# Temp store unique positions for elf 0 and 1.
positions = [ [], [] ]
# found = false

# Loop; generate recipes until target is found.
while true
  if recipes.length % 1000000 == 0
    found, from_index = find_target(target, recipes, from_index)
  end

  break if found

  # Create new recipe, add it to the list.
  new_recipe = new_recipe(recipes, elves)
  new_recipe.each { |r| recipes.append(r) }

  # Compute new positions of all elves.
  elves = new_positions(recipes, elves)
end

puts from_index