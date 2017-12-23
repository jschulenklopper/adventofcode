a,b,c,d,e,f,g,h = 0,0,0,0,0,0,0,0

b = 99
c = 99
b *= 100
b += 100000
c = b
c += 17000

loop do  # label2:
  f = 1
  d = 2
  loop do  # label5:
    e = 2
    loop do # label4:
      g = d
      g *= e
      g -= b
      if g == 0
        f = 0
      end
      e += 1
      g = e
      g -= b
      break if g == 0
    end
    d += 1
    g = d
    g -= b
    break if g == 0
  end
  if f == 0
    h += 1
  end
  g = b
  g -= c
  if g == 0
    puts h
    exit
  end
  b += 17
end
