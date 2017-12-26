# Just copied the spec from the input file. No difficult parsing required.
rules = { "A,0" => [0, 1, +1, "B"],
          "A,1" => [1, 1, -1, "E"],
          "B,0" => [0, 1, +1, "C"],
          "B,1" => [1, 1, +1, "F"],
          "C,0" => [0, 1, -1, "D"],
          "C,1" => [1, 0, +1, "B"],
          "D,0" => [0, 1, +1, "E"],
          "D,1" => [1, 0, -1, "C"],
          "E,0" => [0, 1, -1, "A"],
          "E,1" => [1, 0, +1, "D"],
          "F,0" => [0, 1, +1, "A"],
          "F,1" => [1, 1, +1, "C"],
        }
state = "A"
STEPS = 12523873

checksum = 0
positions = Hash.new(0)
pos = 0

STEPS.times do 
  # Make representation of current situation.
  situation = "%s,%s" % [state, positions[pos]]

  # Pick matching rule.
  rule = rules[situation]

  # Apply changes according to rule.
  positions[pos] = rule[1]
  state = rule[3]
  pos += rule[2]
  checksum = checksum + (rule[1] - rule[0])
end

puts checksum
