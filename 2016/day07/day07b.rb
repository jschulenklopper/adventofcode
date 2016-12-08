count = 0
hypernet = /\[[a-z]+\]/
ababab = /([a-z])((?!\1).)\1[a-z]*\[[a-z]*\2\1\2/

while line = gets do
  supernet_parts = line.strip.split(hypernet) # supernet is between hypernets
  hypernet_parts = line.strip.scan(hypernet) # hypernet is between supernets

  # This is ugly, but we're creating all combinations of
  # supernet and hypernet parts.
  all_parts = supernet_parts.product hypernet_parts
  # And adding the reverse of all combinations as well.
  # (That `sort` is to prevent adding parts to all_parts during block.)
  all_parts.sort.each { |part| all_parts << part.reverse }

  # Now, join all parts into strings.
  all_strings = all_parts.map { |part| part.join }

  # Try to match the ababab pattern against each string.
  all_strings.each do |string|
    if string =~ ababab
      count += 1
      break
    end
  end
end

puts count
