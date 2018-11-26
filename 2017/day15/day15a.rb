FactorA = 16807
FactorB = 48271
Div = 2147483647

a = gets.strip.split(" ").last.to_i
b = gets.strip.split(" ").last.to_i

matches = 0

40000000.times do 
  a = (a * FactorA) % Div
  b = (b * FactorB) % Div
  matches += 1 if (a % 2**16) == (b % 2**16)
end

puts matches