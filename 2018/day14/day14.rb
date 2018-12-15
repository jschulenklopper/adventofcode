nr_recipes = gets.strip.to_i

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

# Loop; generate recipes until there's sufficient.
while recipes.length < nr_recipes + 10
  # Create new recipe, add it to the list.
  new_recipe = new_recipe(recipes, elves)
  new_recipe.each { |r| recipes.append(r) }

  # Compute new positions of all elves.
  elves = new_positions(recipes, elves)
end

puts recipes[nr_recipes, 10].join