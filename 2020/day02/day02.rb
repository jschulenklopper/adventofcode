list = ARGF.readlines.map { |line| line.match(/(.+): (.+)/).captures }


puts "part 1"

valid = list.count do |policy, password|
  min, max, char = policy.match(/(\d+)-(\d+) (.)/).captures
  # `char` needs to occur min-max times.
  password.count(char).between?(min.to_i,max.to_i)
end
puts valid


puts "part 2"

valid = list.count do |policy, password|
  one, two, char = policy.match(/(\d+)-(\d+) (.)/).captures
  # Only one of these conditions may be true.
  (password[one.to_i-1] == char) ^ (password[two.to_i-1] == char)
end
puts valid
