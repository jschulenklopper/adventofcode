$program = ARGF.readlines
$memory = {}
$mask = ""

$program.each do |line|
  match = line.strip.match(/mask = (.{36})/)
  if match
    $mask = match.captures.first
  else
    address, value = line.match(/mem\[(\d+)\] = (\d+)/).captures.map(&:to_i)
    b_value = value.to_s(2).rjust(36, "0").chars
    b_result = b_value.map.with_index { |c, i| $mask[i] == "X" ? c : $mask[i] }
    result = b_result.join.to_i(2)
    $memory[address] = result
  end
end

puts "part 1"
puts $memory.values.sum

$memory = {}

$program.each do |line|
  match = line.strip.match(/mask = (.{36})/)
  if match
    $mask = match.captures.first
  else
    address, value = line.match(/mem\[(\d+)\] = (\d+)/).captures.map(&:to_i)
    b_address = address.to_s(2).rjust(36, "0").chars

    masked_address = b_address.map.with_index { |c, i|
      case $mask[i]
        when "0" then c
        when "1" then "1"
        when "X" then "X"
      end
    }

    nr_floating_bits = masked_address.count("X")

    addresses = (0 ... 2 ** nr_floating_bits).map do |i|
      floating = i.to_s(2).rjust(nr_floating_bits,"0").chars
      masked_address.map do |m|
        case m
          when "0" then m
          when "1" then "1"
          when "X" then floating.shift
        end
      end.join.to_i(2)
    end

    addresses.each do |address|
      $memory[address] = value
    end
  end
end

puts "part 2"
puts $memory.values.sum

