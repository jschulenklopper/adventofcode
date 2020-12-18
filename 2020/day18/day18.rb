expressions = ARGF.readlines.map(&:strip)

class Integer
  def %(operand)
    # `%` has the same precedence as `*`.
    self + operand
  end
  def **(operand)
    # `**` has higher precedence than `*`.
    self + operand
  end
end

puts "part 1"
puts expressions.sum { |expression| eval(expression.gsub("+", "%")) }

puts "part 2"
puts expressions.sum { |expression| eval(expression.gsub("+", "**")) }
