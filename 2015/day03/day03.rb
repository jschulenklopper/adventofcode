while line = gets
  visited = Hash.new(0)
  pos = [0,0]
  visited[pos] = 1

  line.strip.each_char do |direction|
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
    visited[pos] += 1
  end
  puts visited.length
end