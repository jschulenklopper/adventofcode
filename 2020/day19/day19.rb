def regexp_for(id, expression, root = false)
  if match = expression.match(/([a-z])/)
    regexp = match[1]
  elsif expression.include?("|")
    regexp = "(%s|%s)" % expression.split("|").map { |part| regexp_for(id, part) }
  else expression.include?(" ")
    parts = expression.split(" ")
    if parts.include?(id.to_s)
      regexp = "(?<r#{id}>%s)" % parts.map do |p|
        p.to_i == id ? "\\g<r#{p.to_i}>?" : regexp_for(p.to_i, $rules[p.to_i])
      end.join
    else  
      regexp = "(%s)" % parts.map { |p| regexp_for(p.to_i, $rules[p.to_i]) }.join
    end
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

# Build regular expression for rule 0.
regexp_0 = Regexp.new(regexp_for(0, $rules[0], true))
# Count number of valid (matching) messages.
puts messages.count { |msg| msg.match(regexp_0) }

puts "part 2"

# Change rules 8 and 11 according to instructions.
$rules[8] = "42 | 42 8"
$rules[11] = "42 31 | 42 11 31"

# Rebuild regular expression for rule 0.
regexp_0 = Regexp.new(regexp_for(0, $rules[0], true))

# Count number of valid (matching) messages.
puts messages.count { |msg| msg.match(regexp_0) }
