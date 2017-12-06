config = gets.split.map(&:to_i)
length = config.length
cycles = 0
memory = []

until memory.include?(config) 
  memory.push(config.map {|b| b})

  index = config.index(config.max)
  blocks = config[index]

  config[index] = 0
  blocks.times do |i|
    at = (index + i + 1) % length
    config[at] += 1
  end

  cycles += 1
end

puts cycles
