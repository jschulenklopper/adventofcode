grid = ARGF.readlines.map(&:strip)
                     .map(&:chars)
                     .map { |c| c.map(&:to_i) }

octos = Hash.new

grid.each.with_index do |row,r|
  row.each.with_index do |col,c|
    octos[ [r,c] ] = col
  end
end

def neighbors(key)
  r, c = key[0], key[1]
  delta = [ [-1,-1], [-1, 0], [-1,1],
            [ 0,-1],          [ 0,1],
            [ 1,-1], [ 1, 0], [ 1,1] ]

  delta.map { |dr,dc| [r+dr, c+dc] }
end

def step(octos)
  # Energy level of all octopuses increases.
  octos.each { |key, _| octos[key] += 1 }

  loop do
    # Octopuses with energy level greater than 9 flash.
    # Collect neighbors that will be affected by that.
    around = octos.filter { |_, value| value > 9 }
                  .map do |key, value|
      # Increase energy level so it won't be selected later.
      octos[key] = -10

      # Return valid neighbors that need energy to be increased.
      neighbors(key).select { |key| octos.key?(key) }
    end.flatten(1).sort

    # If no neighbors needs an increase, apparently no octopuses flashed.
    break if around.size == 0

    # Flashing octopuses cause neighbors to increase in energy.
    increased = around.each do |key|
      octos[key] += 1
    end.count
  end

  # Count flashed octopuses, reset energy level back to 0.
  count = octos.filter { |key, value| value < 0 }
               .each { |key, _| octos[key] = 0 }.count
  return octos, count
end

step = 0
total_flashed = 0

while true
  step += 1
  octos, flashed = step(octos)
  total_flashed += flashed

  if flashed == octos.length
    puts "part 2"
    puts step
    exit
  end

  if step == 100
    puts "part 1"
    puts total_flashed
  end
end
