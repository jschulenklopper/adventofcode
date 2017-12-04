puts readlines.reduce(0) { |sum, line| words = line.strip.split
  (words.uniq.length == words.length) ? sum+1 : sum
}
