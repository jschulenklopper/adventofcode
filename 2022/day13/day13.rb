packages = ARGF.readlines
               .map(&:strip)  # Strip lines.
               .select { |l| not l.empty? }  # Remove empty lines.
               .map { |line| eval(line) }    # Convert strings to array.

pairs = packages.each_slice(2)  # Group in pairs.
                .map { |p| p }

class Array
  # Re-implement comparison operator.
  def compare(other, level = 0)
    if other.class == Integer
      self.compare([other])
    elsif other.class == NilClass
      1
    elsif self.length == 0 && other.length == 0
      0
    elsif self.length != 0 && other.length == 0
      1
    elsif self.length == 0 && other.length != 0
      -1
    else
      result = self.first.compare(other.first) 
      (result == 0) ? self[1..-1].compare(other[1..-1]) : result
    end
  end
end

class NilClass
  def compare(other, level = 0)
    if other.class == NilClass
      0
    else
      -1
    end
  end
end

class Integer
  def compare(other, level = 0)
    if other.class == Array
      [self].compare(other)
    elsif other.class == NilClass
      1
    elsif other.class == Integer
      self <=> other
    end
  end
end

puts "part 1"
correct_pairs = pairs.map.with_index do |p, i|
  index = i+1
  # puts "\n== Pair #{index} =="
  left, right = p[0], p[1]
  result = left.compare(right, 0)

  (result < 0) ? index : 0
end.compact

puts correct_pairs.sum

puts "part 2"
packages << [[2]] << [[6]]  # Add divider packages.

packages.sort! { |a,b| a.compare(b) }

# Find indices of divider packages.
divider_idx = packages.map.with_index { |p, i| (p == [[2]] || p == [[6]]) ? i+1 : nil }.compact

puts divider_idx.reduce(&:*)
