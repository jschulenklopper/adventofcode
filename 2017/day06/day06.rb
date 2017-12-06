config = gets.split.map(&:to_i)
cycles = 0
memory = {}

until memory.has_key?(config.to_s) 
  # Store cycle count with string representation of memory banks.
  memory[config.to_s] = cycles 

  # Find bank with most blocks.
  index = config.index(config.max)
  blocks = config[index]

  # Redistribute the blocks from index bank.
  config[index] = 0
  blocks.times do |i|
    config[(index + i + 1) % config.length] += 1
  end

  cycles += 1
end

puts cycles                        # Part 1
puts cycles - memory[config.to_s]  # Part 2, cycle count minus when cycle started.
