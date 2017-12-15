FactorA = 16807
FactorB = 48271
Div = 2147483647

a = 883
b = 879

matches = 0

40000000.times do 
  a = (a * FactorA) % Div
  b = (b * FactorB) % Div
  matches += 1 if (a % 2**16) == (b % 2**16)
end

puts matches
