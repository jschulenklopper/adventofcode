datastream = ARGF.read.strip

def find_marker(string, length)
  (string.length - length).times do |i|
    characters = string[i, length]
    if characters.chars.uniq.length == length
      return i+length
    end
  end
end

puts "part 1"
puts find_marker(datastream, 4)

puts "part 2"
puts find_marker(datastream, 14)
