def remove_cancels(string)
  string.gsub(/!./, "")
end

def remove_garbage(string)
  string.gsub(/<.*?>/, "<>")
end

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
  pretty = remove_cancels(line)
  clean = remove_garbage(pretty)

  puts "less garbage: %s" % [pretty.length - clean.length]
  puts "score: %s" % count(1, clean)
end

