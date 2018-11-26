count = 0
while string = gets
  vowel = ( string.chars.keep_if { |v| v =~ /[aeiou]/ }.length >= 3) ? true : false
  double = string =~ /(\w)\1+/ ? true : false
  common = string =~ /(ab)|(cd)|(pq)|(xy)/ ? true : false

  count += 1 if vowel && double && !common
end
puts count