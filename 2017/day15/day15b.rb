FactorA = 16807
FactorB = 48271
Div = 2147483647

a = 883
b = 879

def nextA(a)
  while true
    a = (a * FactorA) % Div 
    break if a % 4 == 0
  end
  a
end

def nextB(b)
  while true
    b = (b * FactorB) % Div
    break if b % 8 == 0
  end
  b
end

matches = 0
5000000.times do 
  a = nextA(a) 
  b = nextB(b)
  matches += 1 if (a % 2**16) == (b % 2**16)
end

puts matches
