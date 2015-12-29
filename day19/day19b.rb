replacements = Hash.new

goal = ""
start = "e"

def backward(start, replacements)
  results = Array.new
  replacements.each do |to, from|
    (0..start.length-1).reverse_each do |i|
      if (Regexp.new(to) =~ start[i..-1]) == 0
        results << start[0,i] + start[i..-1].sub(to, from)
      end
    end
  end
  results
end

def backward_all(start, replacements)
  results = Array.new
  replacements.each do |to, from|
    results << start.gsub(to, from)
  end
  results
end

def one_backward(start, replacements)
  result = start
  longest_replacement = ""

  # Finding longest replacement
  replacements.each do |to, from|
    if match = Regexp.new(to).match(start) 
      if to.length > longest_replacement.length
        longest_replacement = to
      end
    end
  end
  result.sub!(longest_replacement, replacements[longest_replacement])
end

def filter_shortest(strings)
  min_length = strings[0].length
  strings.each { |s| min_length = s.length if s.length < min_length }
  strings.reject { |s| s.length > min_length }
end

# Reading and registering the input file.
while line = gets do
  replacement_re = /(\w+) => (\w+)/
  goal_re = /(\w+)/
  if match = replacement_re.match(line)
    # Register replacement as {to => from} because of rule collisions for from.
    replacements[match[2]] = match[1]
  elsif match = goal_re.match(line)
    goal = match[1]
  end
end

count = 0
result = goal
until result == "e"
  # Instead of trying more/multiple/best replacements,
  # just try one replacement.
  new_result = one_backward(result, replacements)
  count += 1
  result = new_result
end

puts count
