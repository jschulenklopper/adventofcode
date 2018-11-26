FactorA, FactorB = 16807, 48271
ModA, ModB = 4, 8
Div = 2147483647

a = gets.strip.split(" ").last.to_i
b = gets.strip.split(" ").last.to_i

def nextNumber(prev, factor, div, mod)
  while true
    prev = (prev * factor) % div 
    break if prev % mod == 0
  end
  prev
end

matches = 0
5000000.times do 
  a = nextNumber(a, FactorA, Div, ModA)
  b = nextNumber(b, FactorB, Div, ModB)
  matches += 1 if (a % 2**16) == (b % 2**16)
end

puts matches
