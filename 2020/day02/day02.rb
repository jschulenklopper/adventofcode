list = ARGF.readlines.map(&:strip)

valid = list.select do |line|
  policy, password = line.match(/(.+): (.+)/).captures
  min, max, char = policy.match(/(\d+)-(\d+) (.)/).captures
  # Return the number of valid passwords: `char` needs to occur min-max times.
  password.count(char).between?(min.to_i,max.to_i)
end

puts "part 1"
puts valid.count

valid = list.select do |line|
  policy, password = line.match(/(.+): (.+)/).captures
  one, two, char = policy.match(/(\d+)-(\d+) (.)/).captures
  # Return the number of valid passwords: only one of these conditions may be true.
  (password[one.to_i-1] == char) ^ (password[two.to_i-1] == char)
end

puts "part 2"
puts valid.count
