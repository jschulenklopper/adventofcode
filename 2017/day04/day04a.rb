puts readlines.reduce(0) { |s, l| (l.strip.split.uniq.size == l.strip.split.size) ? s+1 : s }
