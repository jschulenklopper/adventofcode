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
      puts program[first_address]
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
      break
    end
  end
end

# Run program with pc set to 0.
run(program, 0, 1)  # Part 1
run(program, 0, 2)  # Part 2