polymer = ARGF.readline.strip
ARGF.readline  # Ugly way to skip empty line in input.
$rules = ARGF.readlines.map(&:strip).map { |s| s.split(" -> ") }.to_h

class String
  def pairs
    (0 .. self.length-2).map { |i| self[i,2] }
  end
end

def do_steps(polymer, steps)
  # Fill initial pair count hash.
  pairs = Hash.new { |hash,key| hash[key] = 0 }
  polymer.pairs.tally.each { |key,value| pairs[key] = value }

  steps.times do |i|
    pairs.dup.select { |k,v| v > 0 }.each do |pair, count|
      $rules.each do |condition, insert|
        if pair == condition
          pairs[condition[0] + insert] += count
          pairs[insert + condition[1]] += count
          pairs[condition] -= count
        end
      end
    end
  end

  char_count = Hash.new { |hash,key| hash[key] = 0 }
  pairs.each { |key, value| key.chars.each { |c| char_count[c] += value } }

  char_count
end

puts "part 1"
char_count = do_steps(polymer, 10)
puts (char_count.values.max - char_count.values.min) / 2

puts "part 2"
char_count = do_steps(polymer, 40)
puts (char_count.values.max - char_count.values.min) / 2
