start, instructions = ARGF.read.split("\n\n")
lines = start.split("\n").map { |l| l.chars }
columns = lines.transpose.select.with_index { |c, i| c if (i-1) % 4 == 0 }
stacks = {}
columns.each { |c| i = c.pop.to_i; c.delete(" "); stacks[i] = c.reverse }

# Duplicate stacks to use idential start situation for part 2.
original_stacks = Marshal.load(Marshal.dump(stacks))

steps = instructions.split("\n").map { |p|
  step = p.split(" ").map(&:to_i)
  { :nr => step[1], :fro => step[3], :to => step[5] }
}

puts "part 1"

steps.each do |step|
  step[:nr].times do
    crate = stacks[ step[:fro] ].pop
    stacks[step[:to]].push(crate)
  end
end

puts stacks.map { |s| s[1].last }.join

puts "part 2"
stacks = original_stacks

steps.each do |step|
  crates = stacks[ step[:fro] ].pop(step[:nr])
  stacks[step[:to]] += crates
end

puts stacks.map { |s| s[1].last }.join
