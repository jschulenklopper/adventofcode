def compute_length(string)
  if match = string.match(/(\()(?<length>\d+)x(?<repeat>\d+)(\))/)
    length = match[:length].to_i
    repeat = match[:repeat].to_i

    # Size of part before match.
    size = match.pre_match.length

    # Add multiplied size of matched part... recursively.
    size += repeat * compute_length(match.post_match[0, length])

    # Add size of part after match.
    size += compute_length(match.post_match[length, match.post_match.length])
  else
    string.length
  end
end

decompressed = 0

while line = gets do
  decompressed += compute_length(line.strip)
end

puts decompressed
