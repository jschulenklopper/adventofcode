require 'digest'

salt = gets.strip

nr_of_keys = 0
index = -1

memo = {}

until nr_of_keys == 64
  index += 1

  hash = salt + index.to_s
  hash_key = salt + index.to_s

  if memo[hash_key]
    hash = memo[hash]
  else
    2017.times { hash = Digest::MD5.hexdigest(hash) }
    memo[hash_key] = hash
  end

  if match = hash.match(/(\w)\1{2}/) # Three same characters in a row.
    char = match[1]

    # Go forward at most 1000 hashes.
    forward_index = index
    
    found = false

    until found || (forward_index >= index + 1000)  do
      forward_index += 1
      # Can we see this again?
      forward_hash = salt + forward_index.to_s
      forward_hash_key = salt + forward_index.to_s

      if memo[forward_hash_key]
        forward_hash = memo[forward_hash_key]
      else
        2017.times { forward_hash = Digest::MD5.hexdigest(forward_hash) }
        memo[forward_hash_key] = forward_hash
      end

      if forward_match = forward_hash.match("%s{5}" % char)
        nr_of_keys += 1
        break
      end
    end
  end
end  

puts index