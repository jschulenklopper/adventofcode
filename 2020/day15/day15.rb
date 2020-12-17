$numbers = ARGF.readline.split(",").map(&:to_i)

def play_game(rounds, initial_numbers)
  last = initial_numbers.last
  # Mapping of number => rounds in which that number was spoken.
  spoken = Hash.new { |hash, key| hash[key] = [] }
  initial_numbers.each.with_index { |n, i| spoken[n] = [i+1] }

  rounds.times do |round|
    next if initial_numbers[round]
    if spoken[last].length < 2
      last = difference = 0
    else
      last = difference = spoken[last][-1] - spoken[last][-2]
    end
    spoken[difference] << round + 1
  end
  last
end

puts "part 1"
puts play_game(2020, $numbers)

puts "part 2"
puts play_game(30_000_000, $numbers)
