moves = gets

floor = 0
position = 0  # Remember position of last move processed.

moves.chars.each { |move|
    position += 1
    case move
        when "(" then floor += 1
        when ")" then floor -= 1
    end
    break if floor == -1
}

puts position