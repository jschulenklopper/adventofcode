last = ARGV[0].strip
ok = false

def straight_ok(string)
  start = 0
  while start < (string.length)-2 do 
    substring = string[start,3]
    if substring[1] == substring[0].succ &&
         substring[2] == substring[1].succ
      return true
    end
    start += 1
  end
  false
end

def letters_ok(string)
  return false if /[iol]/ =~ string
  true
end

def two_pairs_ok(string)
  return true if /(.)\1+.*(.)\2+/ =~ string
  false
end

until ok
  last = last.succ
  if straight_ok(last) &&
       letters_ok(last) &&
       two_pairs_ok(last)
    ok = true
  end
end

puts last