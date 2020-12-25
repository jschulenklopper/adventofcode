card_key, door_key = ARGF.readlines.map(&:to_i)

SUBJECT, MOD = 7, 20201227

f_step = lambda { |subject, card| (card * subject) % MOD }

puts "part 1"

card_subject, card_loop = 1, 0
until card_subject == card_key
  card_loop += 1
  card_subject = f_step.call(SUBJECT, card_subject)
end

door_subject, door_loop = 1, 0
until door_subject == door_key
  door_loop += 1
  door_subject = f_step.call(SUBJECT, door_subject)
end

encryption_key = 1
card_loop.times do
  encryption_key = f_step.call(door_key, encryption_key)
end

puts encryption_key
