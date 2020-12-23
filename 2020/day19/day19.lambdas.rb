lines = ARGF.readlines.map(&:strip)

class Array
  def my_any?(&block)
    puts "\n%s.any?" % [self.to_s]
    self.any?(block)
  end
end

# Return array of possible combinations of `string` split in two.
# TOFIX as this only works for strings divided in two parts.
def spltr(string)
  return nil if string == nil
  return [[string]] if string.length <= 1
  splits = (0..string.length-2).map { |i| [ string[0..i], string[i+1..-1] ] }
end

def expression_for(expression)
  text = ""
  # Expression can be exact match with character.
  if expression.match(/[a-z]+/)
    return "msg == %s" % [expression]
  # Expression can be several options, separated by "|".
  elsif expression.include?("|")
    return "[%s].any?" % [expression.split("|").map { |part| expression_for(part) }.join(", ")]
  # Expression can be a series of rules.
  else expression.include?(" ")
    parts = expression.split(" ")
    sub_expression = parts.map.with_index { |p,i| "rules[#{p}].call(split[#{i}])"}.join(" && ")
    # Since we don't know how parts need to be split, we test them all.
    return "msg.length >= 2 && spltr(msg).any? { |split| %s }" % [sub_expression]
  end
end

rules = {}
# Read all the rules, create a lambda function for each one.
while line = lines.shift
  break if line.empty?
  id, expression = line.match(/(\d+): (.*)$/).captures
  # Create lambda function by evaluating text string of lambda function.
  rules[id.to_i] = eval("lambda { |msg| %s }" % [expression_for(expression)])
end

messages = []
while line = lines.shift
  messages << line
end

count = 0
messages.each do |message|
  puts message
  puts count
  if rules[0].call(message) 
    count += 1 
  end
end

puts count
