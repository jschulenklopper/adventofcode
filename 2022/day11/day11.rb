monkeys = Hash.new # { |h, k| Hash.new }

def print(id, monkey)
  "Monkey #{id}: #{monkey[:items].to_s} (#{monkey[:count]} inspections)"
end

# Process input file.
monkey = Hash.new
ARGF.each_line.map(&:strip).each do | line |
  if match = line.match(/^Monkey (\d+):/)
    monkey[:count] = 0
    monkeys[match[1]] = monkey
  elsif match = line.match(/Starting items: (.+)/)
    monkey[:items] = match[1].split(", ").map(&:to_i)
  elsif match = line.match(/Operation: (.+)/)
    monkey[:operation] = match[1]
  elsif match = line.match(/Test: divisible by (\d+)/)
    monkey[:test] = match[1].to_i
  elsif match = line.match(/If true: throw to monkey (\d+)/)
    monkey[:if_true] = match[1]
  elsif match = line.match(/If false: throw to monkey (\d+)/)
    monkey[:if_false] = match[1]
  else
    monkey = Hash.new
  end
end

monkeys2 = Marshal.load( Marshal.dump(monkeys) )

puts "part 1"
20.times do |i|
  monkeys.keys.sort.each do |id|
    monkey = monkeys[id]

    monkey[:items].each do |item|
      # Increase inspection count.
      monkey[:count] += 1

      # Hack to eval operation on (local) variables immediately.
      old, new = item, nil
      eval(monkey[:operation])

      # Lower anxiety.
      new = new / 3

      # Determine monkey to throw item to.
      to_monkey = (new % monkey[:test]) == 0 ? monkey[:if_true] : monkey[:if_false]

      # Throw item to to_monkey, remove item from item list of monkey.
      monkeys[to_monkey][:items] << new
    end
    monkey[:items] = []
  end
end

# Find two most active monkeys, multiple inspection counts.
puts monkeys.map { |k,m| m[:count] }.sort.last(2).reduce(&:*)


puts "part 2"
# Set back original monkey data to `monkeys` variable.
monkeys = monkeys2

# Calculate the combined module (from Chinese Remainder Theorem).
combined_modulo = monkeys.map { |k, m| m[:test] }.reduce(&:*)

10000.times do |i|
  monkeys.keys.sort.each do |id|
    monkey = monkeys[id]

    monkey[:items].each do |item|
      # Increase inspection count.
      monkey[:count] += 1
      
      # Hack to eval operation on (local) variables immediately.
      old, new = item, nil
      eval(monkey[:operation])

      # Determine monkey to throw item to.
      to_monkey = (new % monkey[:test]) == 0 ? monkey[:if_true] : monkey[:if_false]

      # Lower anxiety level.
      new = new % combined_modulo

      # Throw item to to_monkey, remove item from item list of monkey.
      monkeys[to_monkey][:items] << new
    end
    monkey[:items] = []
  end
end

# Find two most active monkeys, multiple inspection counts.
puts monkeys.map { |k,m| m[:count] }.sort.last(2).reduce(&:*)
