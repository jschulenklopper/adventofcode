require '../../aoc'

MAGIC_NUMBER = 19690720

lines = read_input("2019", "2")
line = lines.first

# Read instructions into positions.
POSITIONS = line.strip.split(",").map(&:to_i)

(0..99).each do |noun|
  (0..99).each do |verb|
    positions = POSITIONS.dup

    positions[1], positions[2] = noun, verb

    current = 0
    running = true

    while running do
      # puts "positions[%i]: %s" % [current, positions[current]]
      case positions[current]
      when 1 then
        new_value = positions[positions[current + 1]] + positions[positions[current + 2]]
        positions[positions[current + 3]] = new_value
      when 2 then
        new_value = positions[positions[current + 1]] * positions[positions[current + 2]]
        positions[positions[current + 3]] = new_value
      when 99 then
        running = false
      else
        running = false
      end

      current += 4
    end

    if positions[0] == MAGIC_NUMBER
      puts 100 * positions[1] + positions[2]
    end

  end
end