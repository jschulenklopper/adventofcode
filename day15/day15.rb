require 'pry'

class Ingredient
  attr_reader :name

  def initialize(string)
    @name = string
  end
  
  def to_s
    @name
  end

  def method_missing(property, value)
    instance_variable_set(("@" + property.to_s).to_sym, value.to_s)
  end
end

def distribute(total, ingredients)
  yield ({ingredients.first => total}) and return if ingredients.length == 1

  ingredient = ingredients.first
  (0..total).each do |amount|
    distribute(total - amount, ingredients - [ingredient] ) do |distribution|
      yield ({ingredient=>amount}.merge(distribution))
    end
  end
end

def compute_score(combination)
  score = 1

  %w(capacity durability flavor texture).each do |property|
    subscore = 0
    combination.each do |ingredient, amount|
      subscore += amount * ingredient.instance_variable_get("@#{property}").to_i
    end
    subscore = 0 if subscore < 0
    score *= subscore
  end
  score
end

ingredients = Array.new

while line = gets
  pattern = /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/

  ingredient = Ingredient.new(pattern.match(line)[1])

  %w(capacity durability flavor texture calories).each_with_index do |property, i|
    ingredient.send(property, pattern.match(line)[i+2].to_i)
  end

  ingredients << ingredient
end

c = Array.new
max_score = 0

distribute(100, ingredients) do |combination|
  score = compute_score(combination)
  max_score = score if score > max_score
  c << combination
end


puts max_score
