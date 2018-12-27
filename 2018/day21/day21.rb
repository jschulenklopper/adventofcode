program = []
ip_register = nil

# Start reading the program.
while line = gets
  if line == nil || line.strip.empty?
    break
  elsif line.match(/#ip (\d)/) && ip_register = line.match(/#ip (\d)\s.*$/).captures.first.to_i
    # Bind instruction pointer is register as set here.
    next
  else
    instruction = line.match(/(\w+)\s(\d+)\s(\d+)\s(\d+)\s.*$/).captures
    program << [instruction[0].to_sym, instruction[1].to_i, instruction[2].to_i, instruction[3].to_i]
  end
end

ip_register = 2 # TODO Remove this line.

operations = {
  # addr (add register) stores into register C
  # the result of adding register A and register B.
  addr: lambda { |registers, a, b, c| registers[c] = registers[a] + registers[b] },
  # addi (add immediate) stores into register C
  # the result of adding register A and value B.
  addi: lambda { |registers, a, b, c| registers[c] = registers[a] + b },

  # mulr (multiply register) stores into register C
  # the result of multiplying register A and register B.
  mulr: lambda { |registers, a, b, c| registers[c] = registers[a] * registers[b] },
  # muli (multiply immediate) stores into register C
  # the result of multiplying register A and value B.
  muli: lambda { |registers, a, b, c| registers[c] = registers[a] * b },

  # banr (bitwise AND register) stores into register C
  # the result of the bitwise AND of register A and register B.
  banr: lambda { |registers, a, b, c| registers[c] = registers[a] & registers[b] },
  # bani (bitwise AND immediate) stores into register C
  # the result of the bitwise AND of register A and value B.
  bani: lambda { |registers, a, b, c| registers[c] = registers[a] & b },

  # borr (bitwise OR register) stores into register C
  # the result of the bitwise OR of register A and register B.
  borr: lambda { |registers, a, b, c| registers[c] = registers[a] | registers[b] },
  # bori (bitwise OR immediate) stores into register C
  # the result of the bitwise OR of register A and value B.
  bori: lambda { |registers, a, b, c| registers[c] = registers[a] | b },

  # setr (set register) copies the contents of register A into register C.
  # (Input B is ignored.)
  setr: lambda { |registers, a, b, c| registers[c] = registers[a] },
  # seti (set immediate) stores value A into register C.
  # (Input B is ignored.)
  seti: lambda { |registers, a, b, c| registers[c] = a },

  # gtir (greater-than immediate/register) sets register C to 1
  # if value A is greater than register B. Otherwise, register C is set to 0.
  gtir: lambda { |registers, a, b, c| registers[c] = (a > registers[b]) ? 1 : 0 },
  # gtri (greater-than register/immediate) sets register C to 1
  # if register A is greater than value B. Otherwise, register C is set to 0.
  gtri: lambda { |registers, a, b, c| registers[c] = (registers[a] > b) ? 1 : 0 },
  # gtrr (greater-than register/register) sets register C to 1
  # if register A is greater than register B. Otherwise, register C is set to 0.
  gtrr: lambda { |registers, a, b, c| registers[c] = (registers[a] > registers[b]) ? 1 : 0 },

  # eqir (equal immediate/register) sets register C to 1
  # if value A is equal to register B. Otherwise, register C is set to 0.
  eqir: lambda { |registers, a, b, c| registers[c] = (a == registers[b]) ? 1 : 0 },
  # eqri (equal register/immediate) sets register C to 1
  # if register A is equal to value B. Otherwise, register C is set to 0.
  eqri: lambda { |registers, a, b, c| registers[c] = (registers[a] == b) ? 1 : 0 },
  # eqrr (equal register/register) sets register C to 1
  # if register A is equal to register B. Otherwise, register C is set to 0.
  eqrr: lambda { |registers, a, b, c| registers[c] = (registers[a] == registers[b]) ? 1 : 0 }
}

instruction_counts = [] # Array of instruction counts, indexed by value register 0.
register_0 = 0

ITERATION_CAP = 100_000 # Stop program after 100 iterations anyway.

# Run program, see if it halts for increasing number for register 0 start value.
while register_0 < 1000000
  registers = [register_0, 0, 0, 0, 0, 0]
  instruction_count = 0

  ip = 0
  iteration_count = 0

  puts "-> begin with register_0 = %i, thus %s" % [register_0, registers.to_s]

  while (iteration_count += 1) < ITERATION_CAP
    # Get instruction.
    puts
    instruction = program[ip]
    opcode, a, b, c = instruction

    # Write value of ip to register.
    registers[ip_register] = ip

    # Apply operation, passing arguments a, b, c
    puts "  (%i) %s(%i, %i, %i)" % [ip, opcode.to_s, a, b, c]
    operations[opcode].(registers, a, b, c)
    puts "  \t\t\t%s" % [registers.to_s]
    instruction_count += 1

    # Write value of register back to ip.
    ip = registers[ip_register]

    # Update ip
    ip += 1

    break if ip < 0 || ip >= program.length
  end

  puts "program halted for register[0] == %i after %i instructions" % [register_0, instruction_count]

  instruction_counts[register_0] = instruction_count

  register_0 += 1
end

puts instruction_counts.length
puts minimum = instruction_counts.min
puts instruction_counts.index(minimum)