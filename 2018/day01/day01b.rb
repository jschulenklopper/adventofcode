freq = 0
freqs = []
deltas = []
index = 0

while delta = gets
  deltas << delta.strip.to_i
end

until freqs.include?(freq)
  freqs << freq
  freq += deltas[index % deltas.length]
  index += 1
end

puts freq