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
  # puts "distribute(%d, %s)" % [total, ingredients.to_s]

  # binding.pry

  yield ingredients and return if ingredients.length == 0

  ingredients.each do |ingredient|
    distribute(100, ingredients - [ingredient]) do |distribution|
      yield [ingredient] + distribution
    end
  end
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

max_score = 0

distribute(100, %w(a b c d)) do |distr|
  p distr
  # score = compute_score(distr)
  # max_score = score if score > max_score
end

# puts max_score
