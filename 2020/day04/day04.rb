# Read passport sections, handle that one passport might be on multiple lines.
passports = ARGF.read.split("\n\n").map { |line| line.gsub("\n", " ") }

required = %w(byr iyr eyr hgt hcl ecl pid)
optional = %w(cid)

puts "part 1"

valid = 0
passports.each do |passport|
  # Get all passport field keys.
  keys = passport.split(" ").map { |field| field.split(":").first }
  # Check whether all required keys are present.
  valid += 1 if (required - keys).length == 0
end
puts valid

puts "part 2"

# Specify functions to check the value for a passport key.
$checks = {
  "byr" => lambda { |value| value.to_i.between?(1920, 2002) },
  "iyr" => lambda { |value| value.to_i.between?(2010, 2020) },
  "eyr" => lambda { |value| value.to_i.between?(2020, 2030) },
  "hgt" => lambda { |value| value[-2,2] == "cm" && value[0..-3].to_i.between?(150,193) ||
                            value[-2,2] == "in" && value[0..-3].to_i.between?(59,76) },
  "hcl" => lambda { |value| value.match?(/^#[0-9a-f]{6}$/) },
  "ecl" => lambda { |value| %w(amb blu brn gry grn hzl oth).include?(value) },
  "pid" => lambda { |value| value.match?(/^\d{9}$/) },
  "cid" => lambda { |_| true }
}

valid = 0
passports.each do |passport|
  # Build array of key-value pairs.
  pairs = passport.split(" ").map { |field| field.split(":") }
  # Check whether required fields are present.
  keys_present = (required - pairs.map(&:first)).length == 0
  # Check whether values are valid with specific lambda function to check the value.
  value_invalid = pairs.map { |key, value| $checks[key].call(value)}.include?(false)
  # It's valid if all required keys are present and no values are invalid.
  valid += 1 if keys_present && ! value_invalid
end

puts valid
