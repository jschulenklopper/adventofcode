require 'digest'

salt = gets.strip

nr_of_keys = 0
index = 0

until nr_of_keys == 64
  hash = Digest::MD5.hexdigest(salt + index.to_s)

  if match = hash.match(/(\w)\1{2}/) # Three same characters in a row.
    char = match[1]

    # Go forward at most 1000 hashes.
    forward_index = index
    found = false

    until found || (forward_index >= index + 1000)  do
      forward_index += 1
      # Can we see this again?
      forward_hash = Digest::MD5.hexdigest(salt + forward_index.to_s)

      if forward_match = forward_hash.match("%s{5}" % char)
        nr_of_keys += 1
        break
      end
    end
  end

  index += 1
end  

puts index - 1  # Minus 1 because we increase index once too often.
