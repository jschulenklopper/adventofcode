decompressed = 0

while line = gets do
  line.strip!
  
  index = 0

  while match = line.match(/(\()(?<length>\d+)x(?<repeat>\d+)(\))/, index)
      length = match[:length].to_i
      repeat = match[:repeat].to_i

      # The new line is the part before the match...
      line = match.pre_match + 
             # plus the part of post_match that needs to be repeated...
             match.post_match[0, length].to_s * repeat +
             # plus the remaining part of post_match.
             match.post_match[length, match.post_match.length]

      index += length * repeat
  end
  decompressed += line.length
end

puts decompressed