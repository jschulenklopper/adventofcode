# Read rules for ticket fields until empty line.
$rules = {}
$fields = []
while line = ARGF.readline.strip do
  break if line.empty?
  field, ranges_text = line.match(/^([\w ]+): (\d+\-\d+.*)/).captures
  ranges = ranges_text.split(" or ").map do |text|
    range = text.split("-").first.to_i .. text.split("-").last.to_i
  end
  $rules[field.to_sym] = ranges
  $fields << field.to_sym
end

until "your ticket:" == ARGF.readline.strip do end
  
# Read numbers on ticket.
$ticket = ARGF.readline.split(",").map(&:to_i)

until "nearby tickets:" == ARGF.readline.strip do end

# Read number on nearby tickets.
$nearby = ARGF.readlines.map { |line| line.strip.split(",").map(&:to_i) }


$valid = $nearby.dup  # Array of valid tickets; assume every ticket is valid.
invalid = 0           # Sum of invalid ticket values.

# Remove ticket from $valid once we know it's invalid.
$nearby.each do |ticket|
  ticket.each do |value|
    if $rules.none? { |name, fields| fields.any? { |range| range.include?(value) } }
      $valid.delete(ticket)
      invalid += value
    end
  end
end

puts "part 1"
puts invalid

# Build  mapping, and (in the beginning) assume that all rules might apply.
# mapping = { ticket_field (as index on ticket) => possible_rules (as key) }
mapping = []
$rules.size.times do
  mapping << $rules.keys
end

until mapping.all? { |map| map.length == 1 } 
  # Process all tickets, and delete fields from mappings that can't apply.
  $valid.each do |ticket|
    # Process all ticket values.
    ticket.each.with_index do |value, index|
      # Iterate over all rules.
      $rules.each do |field, ranges|
        # Check whether ticket value does not match rule's ranges.
        unless ranges.any? { |r| r.include?(value) }
          mapping[index].delete(field)  # Then delete field from mapping.
        end
      end
    end
  end

  # Remove a field from other mappings if it's the sole field in a mapping.
  $fields.each do |field|
    mapping.each.with_index do |map, outer_index|
      if map.length == 1 && map.first == field
        # Scrub field from other mappings.
        mapping.each.with_index do |_, index|
          mapping[index].delete(field) if index != outer_index
        end
      end
    end
  end
end

puts "part 2"
puts $ticket.select.with_index { |value, index|
  value if mapping[index][0].to_s.start_with?("departure")
}.reduce(:*)
