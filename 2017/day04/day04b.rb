puts readlines.count { |line| 
  line.split.map {|words| words.chars.sort}.uniq.size == line.split.size
}
