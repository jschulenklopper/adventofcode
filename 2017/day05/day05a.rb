offsets = readlines.map! { |o| o.strip.to_i }

index = 0
count = 0

until index < 0 || index >= offsets.length do
  count += 1
  offset = offsets[index]
  offsets[index] += 1
  index += offset
end

p count
