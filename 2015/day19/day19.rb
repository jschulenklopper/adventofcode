replacements = Hash.new
start = String.new

while line = gets do
  replacement_re = /(\w+) => (\w+)/
  start_re = /(\w+)/
  
  if match = replacement_re.match(line)
    # Register replacement as {to => from} because of rule collisions for from.
    replacements[match[2]] = Regexp.new(match[1])
  elsif match = start_re.match(line)
    start = match[1]
  end
end

# Collect the results of one replacement (for all possible ones) on each start.
results = Array.new
replacements.each do |to, from|
  (0..start.length-1).each do |i|
    if (from =~ start[i..-1]) == 0
      results << start[0,i] + start[i..-1].sub(from,to)
    end
  end
end

# Uniqify the resulting set, and return the length.
puts results.uniq.length