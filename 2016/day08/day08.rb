ROWS, COLUMNS = 6, 50 
screen = Array.new(ROWS) { Array.new(COLUMNS, ".") } 

while line = gets do
  if /rect (?<x>\d+)x(?<y>\d+)/ =~ line.strip
    (0...y.to_i).each { |row| (0...x.to_i).each { |col| screen[row][col] = "#" } } 
  elsif /rotate row y=(?<row>\d+) by (?<delta>\d+)/ =~ line.strip
    delta.to_i.times { screen[row.to_i] = screen[row.to_i].rotate(-1) }
  elsif /rotate column x=(?<column>\d+) by (?<delta>\d+)/ =~ line.strip
    screen = screen.transpose  # Cheap trick to address columns as rows.
    delta.to_i.times { screen[column.to_i] = screen[column.to_i].rotate(-1) }
    screen = screen.transpose  # And transpose it back.
  end
end

puts screen.flatten.count("#")

screen.each do |row|
  puts row.join
end