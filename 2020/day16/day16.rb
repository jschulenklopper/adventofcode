$rules = {}
# Read rules for ticket fields until empty line.
while line = ARGF.readline.strip do
  break if line.empty?
  field, ranges_text = line.match(/^([\w ]+): (\d+\-\d+.*)/).captures
  ranges = ranges_text.split(" or ").map do |text|
    range = text.split("-").first.to_i .. text.split("-").last.to_i
  end
  $rules[field] = ranges
end

# puts "\nrules:"
# puts $rules.to_s

line = ARGF.readline.strip until "your ticket:" == line 
  
$ticket = []
# Read numbers on ticket.
while line = ARGF.readline.strip do
  break if line.empty?
  $ticket = line.split(",").map(&:to_i)
end

# puts "\nticket:"
# puts $ticket.to_s

line = ARGF.readline.strip until "nearby tickets:" == line 

# Read number on nearby tickets.
$nearby = ARGF.readlines.map { |line|
  line.strip.split(",").map(&:to_i)
}

# puts "\nnearby:"
# puts $nearby.to_s

$valid = $nearby.dup  # Array of valid tickets.
invalid = []  # List of invalid ticket numbers.

$nearby.each do |ticket|
  ticket.each do |value|
    is_invalid = $rules.none? { |name, fields|
      fields.any? { |range| range.include?(value) }
    }
    if is_invalid
      invalid << value
      $valid.delete(ticket)
    end
  end
end

# puts "\nvalid tickets:"
# puts $valid.to_s

puts "part 1"
puts invalid.sum
