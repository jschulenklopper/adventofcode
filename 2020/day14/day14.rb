$program = ARGF.readlines
$memory = {}
mask = ""

puts "part 1"

$program.each do |line|
  match = line.strip.match(/mask = (.{36})/)
  if match
    mask = match.captures.first
  else
    address, value = line.match(/mem\[(\d+)\] = (\d+)/).captures.map(&:to_i)
    value_bits = value.to_s(2).rjust(36, "0")
    result_bits = value_bits.chars.map.with_index { |c, i| (mask[i] == "X") ? c : mask[i] }.join
    result = result_bits.to_i(2)
    $memory[address] = result
  end
end

puts $memory.values.reduce(&:+)
