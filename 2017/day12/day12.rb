$programs = Hash.new(Array.new)

def bfc(id)
  all = []
  queue = [id]

  while node = queue.pop
    all << node unless all.include?(node)
    $programs[node].each { |n| queue.push(n) unless all.include?(n) }
  end

  return all
end

while line = gets
  line.match(/^(?<from>\w+) \<-\> (?<to>.+)$/) do |match|
    from = match[:from].to_i
    to = match[:to].split(", ").map(&:to_i)

    to.each do |program|
		  $programs[from] += [program] unless $programs[from].include?(program)
      $programs[program] += [from] unless $programs[program].include?(from)
    end
   
  end
end

puts "size of group %s: %s" % [0, bfc(0).length]

msts = []
$programs.each { |n, _|
  mst = bfc(n)
  msts.push(mst.sort) unless msts.include?(mst.sort)
}

puts msts.length
