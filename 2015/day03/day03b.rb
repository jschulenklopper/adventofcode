while line = gets
  visited = Hash.new(0)
  santa_pos = [0,0]
  robo_pos = [0,0]
  visited[[0,0]] = 2
  turn = 0

  line.strip.each_char do |direction|
    pos = (turn % 2 == 0) ? santa_pos : robo_pos

    case direction
      when "^"
        pos = [pos[0], pos[1]-1]
      when ">"
        pos = [pos[0]+1, pos[1]]
      when "v"
        pos = [pos[0], pos[1]+1]
      when "<"
        pos = [pos[0]-1, pos[1]]
    end

    if turn % 2 == 0
      santa_pos = pos
    else
      robo_pos = pos
    end

    visited[pos] += 1

    turn += 1
  end
  puts visited.length
end