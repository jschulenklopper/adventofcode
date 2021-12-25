lines = ARGF.readlines.map(&:strip)
$balancer = { "(" => ")",  "[" => "]",  "{" => "}",  "<" => ">" }

def illegal_or_completing(string, expecting)
  return [nil,expecting] if string.empty?

  first, rest = string[0], string[1..] # TIL
  expect, remaining = expecting[0], expecting[1..]

  # Handle the possible cases:
  if first == expect
    # - An expected closing char -> remove closing char from expectation.
    return illegal_or_completing(rest, remaining)
  elsif $balancer.keys.include?(first)
    # - An opening char -> add corresponding closing char to expectation.
    return illegal_or_completing(rest, $balancer[first] + expecting)
  elsif $balancer.values.include?(first)
    # - A not-expected closing char with non-empty `string` -> error.
    return [first,nil]
  end
end

# Find scores of corrupted lines.
scores = lines.map do |line|
  if illegal = illegal_or_completing(line, "")[0]
      {")" => 3,"]" => 57,"}" => 1197,">" => 25137}[illegal] # TIL
  end
end.compact

puts "part 1"
puts scores.sum

scores = lines.map do |line|
  if completing = illegal_or_completing(line, "")[1]
    completing.chars.map { |c|
        { ")" => 1, "]" => 2, "}" => 3, ">" => 4 }[c]
    }.reduce(0) { |score, point| score * 5 + point }
  end
end.compact

puts "part 2"
p scores.sort[(scores.length-1)/2]
