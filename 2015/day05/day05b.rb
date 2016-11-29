count = 0
while string = gets
  pair = string =~ /(\w\w).*\1+/ ? true : false
  repeat = string =~ /(\w).\1/ ? true : false

  count += 1 if pair && repeat
end
puts count
