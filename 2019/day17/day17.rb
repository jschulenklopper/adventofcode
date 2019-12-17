# Read input line into program's instructions.
line = ARGF.readlines.first
program = Hash.new { |hash, key| hash[key] = 0 }
line.strip.split(",").map.with_index { |num, index| program[index] = num.to_i }

def address(program, position, mode, base)
  case mode
    when 0 then program[position]
    when 1 then position
    when 2 then program[position]+base
  end
end

def run(program, pc = 0, input = 0)
  # Parameter modes:
  #   0: position mode, parameters are interpreted as position.
  #   1: immediate node, parameters are interpreted as value.
  #   2: relative mode, parameters are interpreted as relative position.

  # Set the starting relative base.
  base = 0

  # Start collection output.
  output = []

  while true do
    value = program[pc]
    opcode = ("%02s" % value)[-2,2].to_i  # Opcode is last two digits of first value.

    # Parameter mode are right to left in string, starting from third position from end.
    modes = ("%05s" % value)[0...-2].to_s.reverse.chars.map(&:to_i)

    first_address  = address(program, pc+1, modes[0], base)
    second_address = address(program, pc+2, modes[1], base)
    third_address  = address(program, pc+3, modes[2], base)

    case opcode
    when 1 then  # opcode 1: addition
      program[third_address] = program[first_address] + program[second_address]
      pc += 4
    when 2 then  # opcode 2: multiplication
      program[third_address] = program[first_address] * program[second_address]
      pc += 4
    when 3 then  # opcode 3: store
      program[third_address] = input
      pc += 2
    when 4 then  # opcode 4: output
      output << program[first_address]
      pc += 2
    when 5 then  # opcode 5: jump if true
      if program[first_address] != 0
        pc = program[second_address]
      else
        pc += 3
      end
    when 6 then  # opcode 6: jump if false
      if program[first_address] == 0
        pc = program[second_address]
      else
        pc += 3
      end
    when 7 then  # opcode 7: less than
      program[third_address] = (program[first_address] < program[second_address]) ? 1 : 0
      pc += 4
    when 8 then  # opcode 8: equals
      program[third_address] = (program[first_address] == program[second_address]) ? 1 : 0
      pc += 4
    when 9 then  # opcode 9: adjust relative base
      base += program[first_address]
      pc += 2
    when 99 then
      return output
    end
  end
end

# Run program to get camera view.
view = run(program, 0, 0)

image = Hash.new { |hash,key| hash[key] = "." }
# Discover row length by locating first newline.
image_width = view.find_index(10) + 1
image_height = view.length / image_width

# Build camera image from view.
view.each.each_with_index do |code, index|
  char = code.chr
  x = index % image_width
  y = (index / image_width).floor
  image[ [x,y] ] = code.chr
end

# (0...image_height).each do |y|
#   line = ""
#   (0...image_width).each do |x|
#     line += image[ [x,y] ]
#   end
#   puts line
# end

# Find all scaffold intersections.
intersections = image.select { |k,v|
  x = k[0]; y = k[1]
  image[ [x,y] ] == "#" &&
    (x > 0 && image[ [x-1, y] ] == "#") && 
    (x < image_width - 1 && image[ [x+1, y] ] == "#") && 
    (y > 0 && image[ [x, y-1] ] == "#") && 
    (y < image_height - 1 && image[ [x, y+1] ] == "#")
}

# Compute sum of alignment parameters of intersections.
puts intersections.map { |k,v| k[0] * k[1] }.sum