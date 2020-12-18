expressions = ARGF.readlines.map(&:strip)

class Integer
  def %(operand)   # Overload `%` operator to do addition.
    self + operand
  end
  def **(operand)  # Overload `**` operator to do addition too.
    self + operand
  end
end

puts "part 1"
puts expressions.sum { |expression| eval(expression.gsub("+", "%")) }

puts "part 2"
puts expressions.sum { |expression| eval(expression.gsub("+", "**")) }
