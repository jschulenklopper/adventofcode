require 'digest'

salt = gets.strip

nr_of_keys = 0
index = 0

memo = []  # Memoization of hashes.

until nr_of_keys == 64
  puts "hash: %s (at index %d)" % [hash = Digest::MD5.hexdigest(salt + index.to_s), index]

  if match = hash.match(/(\w)\1{2}/) # Three same characters in a row.
    char = match[1]
    puts "X three subsequent %s at index %s" % [char, index]
    char = match[1]

    # Go forward at most 1000 hashes.
    forward_index = index
    
    found = false

    until found || (forward_index >= index + 1000)  do
      forward_index += 1
      # Can we see this again?
      puts "  forward_hash: %s (at forward_index %d)" % [forward_hash = Digest::MD5.hexdigest(salt + forward_index.to_s), forward_index]

      if forward_match = forward_hash.match("%s{5}" % char)
        puts "  X five subsequent %s at forward_index %s (index %d)" % [char, forward_index, index]
        nr_of_keys += 1
        puts "  keys found so far: %s (index %s, forward_index %d)" % [nr_of_keys, index, forward_index]
        break
      end
    end
  end

  index += 1
end  

puts index - 1
