numbers = ARGF.readlines.map(&:to_i)
preamble = 25

puts "part 1"

# Find invalid number by processing all numbers after preamble.
invalid = numbers[preamble, numbers.length-1].select.with_index do |number, i|
  # Build list of sums of all 2-combinations in proper range of numbers.
  sums = numbers[i, preamble].combination(2).map(&:sum)
  # If number isn't in list of sums, we've found the invalid number.
  number unless sums.include?(number)
end.first

puts invalid

puts "part 2"

numbers.each_index do |i|
  # Build ranges (of different lengths).
  (2 .. numbers.length-i).each do |length|
    range = numbers[i, length]
    # If sum of range equals invalid, return sum of max and min in range.
    puts range.min + range.max if range.sum == invalid
  end
end
