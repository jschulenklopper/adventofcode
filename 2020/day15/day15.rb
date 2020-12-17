$numbers = ARGF.readline.split(",").map(&:to_i)

$number_rounds = {}  # Mapping of number => rounds that number was spoken.
$numbers.each.with_index { |n, i| $number_rounds[n] = [i+1] }

def play_game(rounds)
  (1 .. rounds).each do |round|
    next if $numbers[round-1]

    last = $numbers.last

    if $number_rounds[last].length < 2
      $numbers << 0
      $number_rounds[0] << round
    else
      difference = $number_rounds[last][-1] - $number_rounds[last][-2]
      $numbers << difference

      # TODO Optimization: only last two numbers/rounds are necessary.
      $number_rounds[difference] = [] unless $number_rounds[difference]
      $number_rounds[difference] << round
    end
  end
  $numbers.last
end

puts "part 1"
puts play_game(2020)

puts "part 2"
puts play_game(30_000_000)

# Ideas:
# - Computed differences between previous number - looking for a pattern.
# - Selected indexes of zero's - looking for a pattern.
# - Discover repeating pattern -> not yet found.
# - Looking for lowest index number (counted from end) retrieved.
#   - If it increases, then we can prune the beginning, and remember the offset.
# - Count length between zeros, perhaps that increases.           
# - Investigate differences between 1,2,3, and 2,3,1, and 3,1,2.
# - Investigate patterns of 1,2,3, and 1,2,3,4, and 1,2,3,4,5.
# - Investigate which numbers are never retrieved.
# - Big hint: for my input, the size of different numbers is only 15-17%,
#   which could mean a reduction in storage if using a hash instead of array.
#   Suspicion is that the input "5,1,9,18,13,8,0" isn't random, and triggers
#   some pattern that enables storage compression.
# - Investigate which number is being spoken in which round.
# - Duh... build hash of rounds where numbers have been spoken. Easy-peasy.
