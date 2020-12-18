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
puts expressions.reduce(0) { |sum, expression|
  mod_expression = expression.gsub("+", "%")
  sum += eval(mod_expression)
}

puts "part 2"
puts expressions.reduce(0) { |sum, expression|
  mod_expression = expression.gsub("+", "**")
  sum += eval(mod_expression)
}
