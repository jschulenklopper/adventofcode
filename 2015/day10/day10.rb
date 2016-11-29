def look_and_say(string)
  pattern = 
  result = ""
  
  while string.length > 0
    first = /(\d)(\1*)/.match(string)[0]
    length = first.length
    first_part = ((length)).to_s + (first[0]).to_s

    string = string[length, string.length - length]

    result += first_part
  end
  result
end

current = ARGV[0].strip
number = ARGV[1].strip.to_i

number.times do |i|
  puts i+1
  current = look_and_say(current)
end

puts current.length
