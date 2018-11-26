moves = gets  # Get all the moves (which are on a single line).

floor = 0  # Start at ground level.

# Process all the moves, change floor.
moves.chars.each { |move|
    case move
        when "(" then floor += 1
        when ")" then floor -= 1
    end
}

puts floor