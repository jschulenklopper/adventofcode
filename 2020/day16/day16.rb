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

loop do
  line = ARGF.readline.strip
  break if "your ticket:" == line
end
  
# Read numbers on ticket.
$ticket = []
while line = ARGF.readline.strip do
  break if line.empty?
  $ticket = line.split(",").map(&:to_i)
end

loop do
  line = ARGF.readline.strip 
  break if "nearby tickets:" == line 
end

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

def only_one_rule_per_field(mapping)
  mapping.all? { |map| map.length == 1 }
end

def value_fits_rule(value, rule, ranges)
  ranges.any? { |r| r.include?(value) }
end

# Until mapping has only one rule per field,
# * Process all tickets:
#   - Strike rules from fields in mapping if no match according to this ticket.
# * Process all mapping:
#   - Once a field has only one rule, strike rule from other mappings.
loop do
  # Process all tickets, to delete rules from mappings that can't apply.
  $valid.each do |ticket|
    # Process all ticket values.
    ticket.each.with_index do |value, index|
      # Iterate over all rules.
      $rules.each do |rule, ranges|
        # Check whether ticket value does not match rule.
        unless value_fits_rule(value, rule, ranges)
          mapping[index].delete(rule)
        end
      end
    end
  end

  # Process all fields, and remove a field from other mappings
  # if is occurs as the sole field in a mapping.
  $fields.each do |field|
    to_scrub = 0
    mapping.each.with_index do |map, outer_index|
      if map.length == 1 && map.first == field
        mapping.each.with_index do |_, index|
          mapping[index].delete(field) if index != outer_index
        end
      end
    end
  end

  break if only_one_rule_per_field(mapping)
end

puts "part 2"

puts $ticket.map.with_index { |value, index|
  value if mapping[index].first.to_s.start_with?("departure")
}.compact.reduce(:*)
