while line = gets do
  # Parse a line, and get , id and hash.
  name, id, hash = line.strip.match(/^(\D+)(\d+)\[(\w+)\]$/).captures
  letters = name.gsub(/\W/,"")
  id = id.to_i

  # Build a hash of characters and their count.
  dict = Hash.new(0)
  letters.chars.each { |c| dict[c] += 1}

  # Sort the hash keys by their value count, otherwise according to alphabet...
  sorted = dict.sort { |a,b|
    a[1] == b[1] ? a <=> b : b[1] <=> a[1]
  }.slice(0,5).to_h  # ... but only take the first five.

  # Get the check by joining the key characters.
  check = sorted.keys.join

  # If hash equals checksum...
  if hash == check
    # ... rotate the name id times...
    id.times { name = name.tr("abcdefghijklmnopqrstuvwxyz-", "bcdefghijklmnopqrstuvwxyza ") } 
    # ... and print the name if it contains "northpole".
    if name =~ /northpole/
      puts id
    end
  end
end
