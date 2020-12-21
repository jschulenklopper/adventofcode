# Read list of foods (and remove characters we don't need).
lines = ARGF.readlines.map { |line| line.gsub(/\(|\)|,/,"").strip }
foods = []
suspect = Hash.new { |hash, k| hash[k] = [] }

puts "part 1"

lines.each do |line|
  ingredients, allergens = line.split(" contains ").map(&:split)
  # Add ingredients and allergens to store of food items.
  foods << [ingredients, allergens]

  allergens.each do |allergen|
    if suspect[allergen].length > 0
      suspect[allergen] = suspect[allergen] & ingredients
    else
      suspect[allergen] = ingredients
    end
  end
end

ingredients = foods.map(&:first).flatten.uniq

# Safe ingredients are those that aren't in a suspect list.
safe = ingredients - suspect.values.flatten
# Count how often those safe ingredients occur in food items.
puts safe.sum { |ingredient| foods.select { |i,_| i.include?(ingredient) }.count }
