# Read input line into program's instructions.
line = ARGF.readlines.first
program = line.strip.split(",").map(&:to_i)

def run(id, program, pc, input = [0])
  output = nil

  # Parameter modes:
  # - 0: position mode, parameters are interpreted as position.
  # - 1: immediate node, parameters are interpreted as value.

  while true do
    value = program[pc]
    opcode = ("%02s" % value)[-2,2].to_i  # Opcode is last two digits of first value.
    # Parameter mode are right to left in string, starting from third position from end.
    modes = ("%05s" % value)[0...-2].to_s.reverse.chars.map(&:to_i)

    first_address  = (modes[0] == 0) ? program[pc+1] : pc+1
    second_address = (modes[1] == 0) ? program[pc+2] : pc+2
    third_address  = (modes[2] == 0) ? program[pc+3] : pc+3

    case opcode
    when 1 then  # opcode 1: addition
      program[third_address] = program[first_address] + program[second_address]
      pc += 4
    when 2 then  # opcode 2: multiplication
      program[third_address] = program[first_address] * program[second_address]
      pc += 4
    when 3 then  # opcode 3: store
      program[first_address] = input.shift
      pc += 2
    when 4 then  # opcode 4: output
      output = program[first_address]
      pc += 2
      return [ output, pc ]
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
    when 99 then
      return [output, nil]
    end
  end
end

phase_settings = [5,6,7,8,9]
phase_combinations = phase_settings.permutation.map

signals = phase_combinations.map do |p|
  # Set up programs and program counters for amplifiers.
  programs = Array.new(phase_settings.length)
  pcs = Array.new(phase_settings.length)
  phase_settings.length.times do |i|
    programs[i] = program.dup
    pcs[i] = 0
  end

  input = 0

  # First loop, provide phases and input (feeding output of A to B).
  phase_settings.length.times do |i|
    input, pcs[i] = run((i+65).chr, programs[i], pcs[i], [p[i], input])
  end

  # Next loops, just daisy-chain input.
  running = true
  while running
    output = input

    phase_settings.length.times do |i|
      input, pcs[i] = run((i+65).chr, programs[i], pcs[i], [input])
      # If first program halts, stop running the loop.
      if pcs[i] == nil
        running = false
        break
      end
    end
  end
  output
end

puts signals.max