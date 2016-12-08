ROWS = 6
COLUMNS = 50
screen = Array.new(ROWS) { Array.new(COLUMNS, ".") } 

while line = gets do
  if /rect (?<x>\d+)x(?<y>\d+)/ =~ line.strip
    (0...y.to_i).each do |row|
      (0...x.to_i).each do |col|
        screen[row][col] = "#"
      end
    end
  elsif /rotate row y=(?<row>\d+) by (?<delta>\d+)/ =~ line.strip
    delta.to_i.times do 
      screen[row.to_i] = screen[row.to_i].rotate(-1)
    end
  elsif /rotate column x=(?<column>\d+) by (?<delta>\d+)/ =~ line.strip
    screen = screen.transpose
    delta.to_i.times do 
      screen[column.to_i] = screen[column.to_i].rotate(-1)
    end
    screen = screen.transpose
  end
end

puts screen.join { |row| row.join }.count("#")
