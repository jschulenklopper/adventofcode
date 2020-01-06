# Read input line into program's instructions.
line = ARGF.readlines.first
program = line.strip.split(",").map(&:to_i)

pc = 0
input = 1

# Parameter modes:
# - 0: position mode, parameters are interpreted as position.
# - 1: immediate node, parameters are interpreted as value.

while true do
  value = program[pc]
  opcode = ("%02s" % value)[-2,2].to_i  # Opcode is last two digits of first value.
  # Parameter mode are right to left in string, starting from third position from end.
  modes = ("%05s" % value)[0...-2].to_s.reverse.chars.map(&:to_i)
  first  = (modes[0] == 0) ? program[ program[pc + 1] ] : program[pc+1]
  second = (modes[1] == 0) ? program[ program[pc + 2] ] : program[pc+2]
  third  = (modes[2] == 0) ? program[ program[pc + 3] ] : program[pc+3]
  case opcode
  when 1 then  # opcode 1: addition
    if (modes[2] == 0) then
      program[ program[pc + 3] ] = first + second
    else
       program[pc+3] = first + second
    end
    pc += 4
  when 2 then  # opcode 2: multiplication
    if (modes[2] == 0) then
      program[ program[pc + 3] ] = first * second
    else
       program[pc+3] = first * second
    end
    pc += 4
  when 3 then  # opcode 3: store
    if (modes[2] == 0) then
      program[ program[pc + 1] ] = input
    else
       program[pc+1] = input
    end
    pc += 2
  when 4 then  # opcode 4: output
    puts first
    pc += 2
  when 99 then
    break
  end
end