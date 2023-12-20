require 'pp'
games = {}

ARGF.readlines.each do |line|
  game = /Game \d+: (.*)$/.match(line)[1].split("; ")
  samples = []
  game.each do |line|
    sample = {}
    line.split(", ").map { |grab|
      count, color = grab.split(" ")
      sample[color] = count.to_i
    }
    samples << sample
  end
  games[games.length + 1] = samples
end

## Part 1

limits_a = { "red" => 12, "green" => 13, "blue" => 14 }

# Get list of possible games' ids.
possible_games = games.select do |key, game|
  possible = true
  game.each do |set|
    set.each do |color, number|
      possible = false if number > limits_a[color]
    end
  end
  possible
end.keys

# Print sum of ids of possible games.
puts possible_games.sum

## Part 2

powers = games.map do |key, game|
  minimal_set = {}
  game.each do |set|
    set.each do |color, number|
      if minimal_set[color]
        minimal_set[color] = [minimal_set[color], number].max
      else
        minimal_set[color] = number
      end
    end
  end
  minimal_set.values.reduce(:*)
end

puts powers.sum

