nr_recipes = gets.strip.to_i

# Starting recipes.
recipes = [3,7]

# Initial position of two elves.
elves = [0, 1] 

def new(recipes, elves)
  # Strangely enough, digits() returns characters in 'wrong' order.
  (recipes[elves[0]] + recipes[elves[1]]).digits.reverse
end

def positions(recipes, elves)
  elves.map do |position|
    position += (1 + recipes[position])
    position % recipes.length
  end
end

recipes_memo = Hash.new

def shorten
end

# Register number of removed recipes.
removed = 0

# Loop; generate recipes until there's sufficient.
while removed + recipes.length < nr_recipes + 10
  # Create new recipe, add it to the list.
  new_recipe = new(recipes, elves)
  recipes += new_recipe

  recipes = shorten(recipes)
  puts recipes.length if recipes.length % 1000 == 0 # DEBUG

  # Compute new positions of all elves.
  elves = positions(recipes, elves)
end

puts recipes[nr_recipes, 10].join