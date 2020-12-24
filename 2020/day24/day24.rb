lines = ARGF.readlines.map(&:strip)

# Floor tiles stored in hash; coordinate [x,y,z] where x + y  + z = 0.
floor = Hash.new { |hash, k| hash[k] = "." }

moves = { e: lambda { | pos | [ pos[0]+1, pos[1]-1, pos[2] ] },
          D: lambda { | pos | [ pos[0], pos[1]-1, pos[2]+1 ] },  # sw
          B: lambda { | pos | [ pos[0]-1, pos[1], pos[2]+1 ] },  # se
          w: lambda { | pos | [ pos[0]-1, pos[1]+1, pos[2] ] },
          O: lambda { | pos | [ pos[0], pos[1]+1, pos[2]-1 ] },  # nw
          U: lambda { | pos | [ pos[0]+1, pos[1], pos[2]-1 ] }   # ne
        }

puts "part 1"

lines.each do |line|
  position = [0,0,0]
  line = line.gsub(/(se)/, "D").gsub(/sw/, "B").gsub(/nw/, "O").gsub(/ne/, "U")
  line.chars.each { |move| position = moves[move.to_sym].call(position) }
  floor[position] = floor[position] == "." ? "#" : "."
end

puts floor.values.count("#")
