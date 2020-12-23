def regexp_for(expression, root = false)
  if match = expression.match(/([a-z])/)
    regexp = match[1]
  elsif expression.include?("|")
    regexp = "(%s|%s)" % expression.split("|").map { |part| regexp_for(part) }
  else expression.include?(" ")
    parts = expression.split(" ")
    regexp = "(%s)" % parts.map { |p| regexp_for($rules[p.to_i]) }.join
  end
  root ? "^%s$" % regexp : regexp
end

puts "part 1"

$rules = {}
while line = ARGF.readline.strip
  break if line.empty?
  id, expression = line.match(/(\d+): (.*)$/).captures
  $rules[id.to_i] = expression
end

messages = ARGF.readlines.map(&:strip)
regexp_0 = Regexp.new(regexp_for($rules[0], true))
puts messages.count { |msg| msg.match(regexp_0) }
