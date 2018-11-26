sum = 0

while line = gets do
  # Parse a line, and get name, id and hash.
  name, id, hash = line.strip.match(/^(\D+)(\d+)\[(\w+)\]$/).captures
  name = name.gsub(/\W/,"")
  id = id.to_i

  # Build a hash of characters and their count.
  dict = Hash.new(0)
  name.chars.each { |c| dict[c] += 1}

  # Sort the hash keys by their value count, otherwise according to alphabet.
  sorted = dict.sort { |a,b|
    if a[1] == b[1]
      a <=> b
    else
      b[1] <=> a[1]
    end
  }.slice(0,5).to_h # But only take the first five.

  # Get the check by joining the characters of the keys.
  check = sorted.keys.join

  # Add id to sum if the room hash equals the checksum.
  sum += id if hash == check
end

puts sum