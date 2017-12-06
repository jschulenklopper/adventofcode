config = gets.split.map(&:to_i)
cycles = 0
memory = []

until memory.map { |m| m[1] }.include?(config) 
  memory.push([cycles, config.dup])

  index = config.index(config.max)
  blocks = config[index]

  config[index] = 0
  blocks.times do |i|
    config[(index + i + 1) % config.length] += 1
  end

  cycles += 1
end

puts cycles - memory.map { |m| m[1] }.index(config)
