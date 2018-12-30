a, b, ip, d, e, f = [0, 0, 0, 0, 0, 0]

d = 123

while d != 72
  d = d & 456
end

d = 0

# Not in input.txt, but <added_code>
list_of_d = []  # Maintain list of d's.
# </added_code>

while true
  # Not in input.txt, but <added_code>
  if list_of_d.include?(d) 
    puts list_of_d.last  # Print last d added.
    exit
  else
    list_of_d << d  # Add d to list.
  end
  # </added_code>

  puts [a,b,ip,d,e,f].to_s
  e = d | 65536
  d = 2176960

  while true
    b = e & 255
    d += b
    d = d & 16777215
    d *= 65899
    d = d & 16777215

    if e < 256
      break
    end

    b = 0

    while true
      f = b + 1
      f *= 256
      if f > e
        break
      end
      b += 1
    end
    e = b
  end
  if d == a
    break
  end

end