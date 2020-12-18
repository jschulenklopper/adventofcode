expressions = ARGF.readlines.select { |l| l[0] != "#" }.map(&:strip)

class Integer
  def %(other_integer)
    self + other_integer
  end
end

puts "part 1"
puts expressions.reduce(0) { |sum, expression|
  modified_expression = expression.gsub("+", "%")
  sum += eval(modified_expression)
}
