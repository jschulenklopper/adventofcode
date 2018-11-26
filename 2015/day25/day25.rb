# Set target grid position
row, column = 3010, 3019

def grid_number(row,column)
  row_number = (1...row).inject(1) { |sum, n| sum += n }
  column_number = row_number + (1...column).inject(0) { |sum, n| sum += row + n } 
end

cell_number = grid_number(row, column)

# Alternatively:
# cell_number = (row + column - 2) * (row + column - 1) / 2 + column

# Set other constants.
start = 20151125
multiplier = 252533
modulo = 33554393

(cell_number-1).times do
  start = (start * multiplier) % modulo
end

puts start