samples = []
Sample = Struct.new(:before, :instruction, :after)

while true
  # Read samples (three lines)
  first_line = gets
  break if first_line == nil || first_line.strip.empty?

  before = first_line.match(/\[(.*)\]/).captures.first.split(",").map(&:to_i)
  instruction = gets.match(/(\d+)\s(\d+)\s(\d+)\s(\d+)/).captures.each.map(&:to_i)
  after = gets.match(/\[(.*)\]/).captures.first.split(",").map(&:to_i)

  samples << Sample.new(before, instruction, after)

  separator = gets
end

# Start reading the program here.
# TODO

p samples.length

operations = Hash.new # { :name, :lambda }

# addr (add register) stores into register C the result of adding register A and register B.
operations[:addr] = lambda { |registers, a, b, c| registers[c] = registers[a] + registers[b] }
# addi (add immediate) stores into register C the result of adding register A and value B.
operations[:addi] = lambda { |registers, a, b, c| registers[c] = registers[a] + b }

# mulr (multiply register) stores into register C the result of multiplying register A and register B.
operations[:mulr] = lambda { |registers, a, b, c| registers[c] = registers[a] * registers[b] }
# muli (multiply immediate) stores into register C the result of multiplying register A and value B.
operations[:muli] = lambda { |registers, a, b, c| registers[c] = registers[a] * b }

# banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
operations[:banr] = lambda { |registers, a, b, c| registers[c] = registers[a] & registers[b] }
# bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
operations[:bani] = lambda { |registers, a, b, c| registers[c] = registers[a] & b }

# borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
operations[:borr] = lambda { |registers, a, b, c| registers[c] = registers[a] | registers[b] }
# bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
operations[:bori] = lambda { |registers, a, b, c| registers[c] = registers[a] | b }

# setr (set register) copies the contents of register A into register C. (Input B is ignored.)
operations[:setr] = lambda { |registers, a, b, c| registers[c] = registers[a] }
# seti (set immediate) stores value A into register C. (Input B is ignored.)
operations[:seti] = lambda { |registers, a, b, c| registers[c] = a }

# gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
operations[:gtir] = lambda { |registers, a, b, c| registers[c] = (a > registers[b]) ? 1 : 0 }
# gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
operations[:gtri] = lambda { |registers, a, b, c| registers[c] = (registers[a] > b) ? 1 : 0 }
# gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
operations[:gtrr] = lambda { |registers, a, b, c| registers[c] = (registers[a] > registers[b]) ? 1 : 0 }

# eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
operations[:eqir] = lambda { |registers, a, b, c| registers[c] = (a == registers[b]) ? 1 : 0 }
# eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
operations[:eqri] = lambda { |registers, a, b, c| registers[c] = (registers[a] == b) ? 1 : 0 }
# eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
operations[:eqrr] = lambda { |registers, a, b, c| registers[c] = (registers[a] == registers[b]) ? 1 : 0 }

# Example of showing registers, applying operation, showing registers again.
# p registers
# operations[:seti].(1,2,3)
# p registers

count = 0
samples.each do |s|
  puts "\nsample: " + s.to_s
  # Maintain list of possible opcodes.
  possible = []

  # Apply all operations.
  operations.each do |opcode, lambda|
    puts "\ntesting opcode %s for instruction %i" % [opcode.inspect, s.instruction[0]]

    puts "sample: "
    p s

    # Set registers as defined as :before in sample.
    registers = s.before.dup
    puts "PRE  registers: " + registers.to_s

    # Apply one operation, passing arguments 1, 2 and 3.
    p s.instruction
    lambda.(registers, s.instruction[1], s.instruction[2], s.instruction[3])

    # Check if registers match :after in sample.
    puts "POST registers: " + registers.to_s

    if registers == s.after
      puts "registers match expectation"
      possible << opcode
    end
  end

  count += 1 if possible.length >= 3
end

puts count