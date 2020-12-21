# Read list of foods (and remove characters we don't need).
lines = ARGF.readlines.map { |line| line.gsub(/\(|\)|,/,"").strip }
foods, suspect = [], {}

puts "part 1"

lines.each do |line|
  ingredients, allergens = line.split(" contains ").map(&:split)
  # Add ingredients and allergens to store of food items.
  foods << [ingredients, allergens]

  allergens.each do |a|
    # Intersect ingredient list if suspected earlier.
    suspect[a] = (suspect[a]) ? suspect[a] & ingredients : ingredients
  end
end

ingredients = foods.map(&:first).flatten.uniq

# Safe ingredients are ingredients not in a suspect list.
safe = ingredients - suspect.values.flatten
# Count how often safe ingredients occur in food ingredient list.
puts safe.sum { |ingredient| foods.select { |i,_| i.include?(ingredient) }.count }

puts "part 2"

until suspect.map { |_, ingredients| ingredients.length }.uniq.length == 1
  # Find ingredients to strike: ingredients that are the only suspected one.
  to_strike = suspect.values.select { |i| i.length == 1 }.flatten
  suspect.each do |a, i|
    to_strike.each { |strike| suspect[a] -= [strike] if i.length > 1 }
  end
end

# Order suspect ingredients on allergen name.
puts suspect.keys.sort.map { |a,_| suspect[a] }.join(",")
