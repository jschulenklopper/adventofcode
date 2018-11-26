characters = []  # Array of possible characters, for each position stored in hash.
message = ""

while line = gets do
  line.strip.each_char.with_index { |c, i|
    characters[i] = {} if ! characters[i]
    characters[i][c] = 0 if ! characters[i][c]
    characters[i][c] += 1
  }
end

characters.each do |possibilities|
  message << possibilities.max_by { |k,v| v }.first
end

puts message