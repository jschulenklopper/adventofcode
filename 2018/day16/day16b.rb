samples = []
Sample = Struct.new(:before, :instruction, :after)

while true
  # Read samples (three lines)
  first_line = gets
  break if first_line == nil || first_line.strip.empty?

  before = first_line.match(/\[(.*)\]/).captures.first.split(",").map(&:to_i)
  instruction = gets.match(/(\d+)\s(\d+)\s(\d+)\s(\d+)/).captures.map(&:to_i)
  after = gets.match(/\[(.*)\]/).captures.first.split(",").map(&:to_i)

  samples << Sample.new(before, instruction, after)

  separator = gets
end

program = []

# Start reading the program here.
while line = gets
  next if line == nil || line.strip.empty?
  instruction = line.match(/(\d+)\s(\d+)\s(\d+)\s(\d+)/).captures.map(&:to_i)
  program << instruction
end

operations = Hash.new          # { :opcode => :lambda}
opnumber_matches = Hash.new { |h, k| h[k] = [] }  # { :opnumber => [opcodes] }
opcode_matches = Hash.new { |h, k| h[k] = [] }  # { :opcode => [opnumbers] }

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

# count = 0
samples.each do |s|
  # puts "sample %s" % s.to_s

  # Apply all operations.
  operations.each do |opcode, lambda|
    # Set registers as defined as :before in sample.
    registers = s.before.dup

    opnumber = s.instruction[0]

    # Apply one operation, passing arguments 1, 2 and 3.
    lambda.(registers, s.instruction[1], s.instruction[2], s.instruction[3])

    # Check if registers match :after in sample.
    if registers == s.after
      opnumber_matches[opnumber] << opcode
      opcode_matches[opcode] << opnumber
    end
  end
end

# puts "\noperations matches on opnumber:"
# opnumber_matches.each { |o, list| puts o.to_s + ": " + list.uniq.to_s } 

# puts "\noperations matches on opcode:"
# opcode_matches.each { |o, list| puts o.to_s + ": " + list.uniq.to_s } 

# Manual work: figure out mapping between opcodes and opnumbers.
mapping = { addi: 4,
            seti: 1,
            gtri: 7,
            eqrr: 3,
            muli: 8,
            eqri: 2,
            mulr: 15,
            borr: 11,
            gtir: 12,
            gtrr: 6,
            eqir: 0,
            addr: 14,
            bori: 9,
            setr: 5,
            banr: 13,
            bani: 10
}

registers = [0, 0, 0, 0]

program.each do |instruction|
  opnumber, a, b, c = instruction
  # Find opcode for opnumber from instruction.
  opcode = mapping.key(opnumber)

  # Apply operation, passing arguments a, b, c
  operations[opcode].(registers, a, b, c)
end

# Print value of register 0.
puts registers[0]