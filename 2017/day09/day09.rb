def count(level, string)
  return 0 if string == ""
  first = string[0]
  rest = string[1..-1]
  case first
    when "{"
      return level+count(level+1, rest)
    when "}"
      return count(level-1, rest)
    else
      return count(level, rest)
  end
end

while line = gets
  pretty = line.gsub(/!./, "")       # Remove cancelled characters.
  clean = pretty.gsub(/<.*?>/, "<>") # Remove garbage groups.

  puts "score: %s" % count(1, clean)
  puts "garbage: %s" % [pretty.length - clean.length]
end
