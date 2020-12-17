$numbers = ARGF.readline.split(",").map(&:to_i)

def play_game(rounds, initial_numbers)
  last = initial_numbers.last
  spoken = {}  # Mapping of number => rounds that number was spoken.
  initial_numbers.each.with_index { |n, i| spoken[n] = [i+1] }

  (1 .. rounds).each do |round|
    next if initial_numbers[round-1]
    if spoken[last].length < 2
      spoken[0] << round
      last = 0
    else
      difference = spoken[last][-1] - spoken[last][-2]
      spoken[difference] = [] unless spoken[difference]
      spoken[difference] << round
      last = difference
    end
  end
  last
end

puts "part 1"
puts play_game(2020, $numbers)

puts "part 2"
puts play_game(30_000_000, $numbers)
