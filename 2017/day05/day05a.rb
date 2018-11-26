offsets = readlines.map! { |offset| offset.to_i }

index, count = 0, 0

while offset = offsets[index] do
  offsets[index] += 1
  index += offset
  count += 1
end

puts count