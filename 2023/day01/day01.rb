digits_a, digits_b = [], []
textdigits = { "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5,
               "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "zero" => 0,
               "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5,
               "6" => 6, "7" => 7, "8" => 8, "9" => 9, "0" => 0 }

ARGF.readlines.collect do |line|
  # Scan the strings for digits for the first part.
  digits = line.chars.select { |c| c =~ /\d/ }
  digits_a << [digits.first, digits.last]

  # Scan the strings for digits for the second part.
  semidigits = line.scan(Regexp.new((textdigits.keys).join("|")))
  digits_b << [semidigits.first, semidigits.last]
end

# Print total of calibration values for first part of puzzle.
puts digits_a.map { |pair| pair.join.to_i }.sum

# Print total of values for second part.
puts digits_b.map { |pair| [textdigits[pair.first], textdigits[pair.last]].join.to_i }.sum
