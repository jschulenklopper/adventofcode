offsets = readlines
offsets.map! { |o| o.strip.to_i }

index = 0
count = 0

until index < 0 || index >= offsets.length do
  count += 1
  offset = offsets[index]
  if offsets[index] >= 3
    offsets[index] -= 1
  else
    offsets[index] += 1
  end
  index += offset
end

puts count
