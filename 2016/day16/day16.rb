disk_length = 272     # First part of puzzle.
# disk_length = 35651584  # Second part of puzzle.

input = gets.strip
output = input

# Compute values to disk.
while output.length < disk_length
  a = output
  b = a.reverse.chars.map { |c| c == "1" ? "0" : "1" }.join
  output = a + "0" + b
end

# Compute checksum for disk value.
checksum = output[0, disk_length]
loop do
  p pairs = checksum.scan(/.{1,2}/)
  p checksum = pairs.map { |p| (p == "11" || p == "00") ? "1" : "0" }.join
  break if checksum.length.odd?
end

puts checksum
