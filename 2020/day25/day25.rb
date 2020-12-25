card_key = ARGF.readline.to_i
door_key = ARGF.readline.to_i

SUBJECT, MOD = 7, 20201227

# The card transforms the subject number of 7 according to the
# card's secret loop size. The result is called the card's public key.
card_subject, card_loop = 1, 0
until card_subject == card_key
  card_loop += 1
  card_subject = (card_subject * SUBJECT) % MOD
end

door_subject, door_loop = 1, 0
until door_subject == door_key
  door_loop += 1
  door_subject = (door_subject * SUBJECT) % MOD
end

# The card transforms the subject number of the door's public key according
# to the card's loop size. The result is the encryption key.
encryption_key = 1
card_loop.times do
  encryption_key = (encryption_key * door_key) % MOD
end

puts encryption_key
