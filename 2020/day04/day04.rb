# Read passport sections, handle that one passport might be on multiple lines.
passports = ARGF.read.split("\n\n").map { |line| line.gsub("\n", " ") }

required = %w(byr iyr eyr hgt hcl ecl pid)
optional = %w(cid)


puts "part 1"

valid = 0
passports.each do |passport|
  # Get all passport fields.
  fields = passport.split(" ")
  # Get just the keys of the passports.
  keys = fields.map { |field| field.split(":").first }
  # Check whether all required keys are present.
  valid += 1 if (required - keys).length == 0
end

puts valid


puts "part 2"

# Specify a function to check the value for a passport key.
$check = lambda do |key, value|
  case key
  when "byr" then value.to_i.between?(1920, 2002)
  when "iyr" then value.to_i.between?(2010, 2020)
  when "eyr" then value.to_i.between?(2020, 2030)
  when "hgt" then
    value[-2,2] == "cm" && value[0..-3].to_i.between?(150,193) ||
    value[-2,2] == "in" && value[0..-3].to_i.between?(59,76)
  when "hcl" then value.match?(/^#[0-9a-f]{6}$/)
  when "ecl" then %w(amb blu brn gry grn hzl oth).include?(value)
  when "pid" then value.match?(/^\d{9}$/)
  when "cid" then true
  end
end

valid = 0
passports.each do |passport|
  # Build array of key-value pairs.
  pairs = passport.split(" ").map { |field| field.split(":") }

  # Check whether required fields are present.
  keys_present = (required - pairs.map(&:first)).length == 0
  # Check whether values are valid.
  value_invalid = pairs.map { |key, value| $check.call(key, value)}.include?(false)

  # It's valid if all required keys are present and no values are invalid.
  valid += 1 if keys_present && ! value_invalid
end

puts valid
