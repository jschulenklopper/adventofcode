# Read input line into program's instructions.
line = ARGF.readlines.first
program = Array.new  # { |i| # Hash.new { |hash, key| hash[key] = 0 }
line.strip.split(",").map.with_index { |num, index| program[index] = num.to_i }

def address(program, position, mode, base)
  case mode
    when 0 then program[position]
    when 1 then position
    when 2 then program[position]+base
  end
end

# Monkey-patch Array
class Array
  def [](index)
    self.at(index) || 0
  end
end

def run(program, pc = 0, inputs = [0,0])
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
      input = inputs.shift
      program[first_address] = input
      pc += 2
    when 4 then  # opcode 4: output
      return program[first_address]
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
      puts "end of program"
      return
    end
  end
end

SQUARE_SIZE = 99

# Pick X,Y to start.
x,y = [0, SQUARE_SIZE]
while true
  # Walk right, find first X-value within beam.
  while true
    break if run(program.dup, 0, [x,y]) == 1
    x += 1
  end
  # Then test if four corners of square are in beam.
  break if run(program.dup, 0, [x, y]) == 1 && 
           run(program.dup, 0, [x, y-SQUARE_SIZE]) == 1 && 
           run(program.dup, 0, [x+SQUARE_SIZE, y]) == 1 && 
           run(program.dup, 0, [x+SQUARE_SIZE, y-SQUARE_SIZE]) == 1
  y += 1
end

puts (x * 10000) + (y - SQUARE_SIZE)