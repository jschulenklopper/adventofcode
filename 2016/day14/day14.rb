require 'digest'

salt = gets.strip

nr_of_keys = 0
index = -1

memo = []

until nr_of_keys == 64
  index += 1
  hash = memo[index] || memo[index] = Digest::MD5.hexdigest(salt + index.to_s)

  if match = hash.match(/(\w)\1{2}/) # Three same characters in a row.
    char = match[1]

    # Go forward at most 1000 hashes.
    forward_index = index
    found = false

    until found || (forward_index >= index + 1000)  do
      forward_index += 1
      # Can we see this again?
      forward_hash = memo[forward_index] || memo[forward_index] = Digest::MD5.hexdigest(salt + forward_index.to_s)

      if forward_match = forward_hash.match("%s{5}" % char)
        nr_of_keys += 1
        break
      end
    end
  end
end  

puts index
