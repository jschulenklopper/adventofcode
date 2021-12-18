numbers = ARGF.readline.split(",").map(&:to_i)
lines = ARGF.readlines.map(&:strip)

boards = Hash.new

# Process all lines.
lines.each do |line|
  if line.empty?
    # Make a new bingo board once an empty line is seen.
    boards[boards.length] = Array.new
  else
    # Add bingo board rows to board just created.
    boards[boards.keys.max] << line.split(" ").map(&:to_i)
  end
end

def wins?(board)
  # A board wins if a row is empty after removing `nil`.
  board.any? { |row| row.compact.empty? } ||
    # ... or when a column only had `nil` values.
    board.transpose.any? { |row| row.compact.empty? }
end

# List of (scores of) boards that won, in order.
winning_boards = []

numbers.each do |drawn|
  # Find drawn number in all boards.
  boards.each do |id, board|
    board.each.with_index do |row, r|
      row.each.with_index do |number, n|
        boards[id][r][n] = nil if number == drawn
      end
    end
  end

  # Check whether there are winning boards.
  boards.each do |id, board|
    if wins?(board)
      # Add board's score to the list.
      winning_boards << board.flatten.compact.sum * drawn
      boards.delete(id)
    end
  end
end

puts "part 1"
puts winning_boards.first
puts "part 2"
puts winning_boards.last
