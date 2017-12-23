class Instructions < Array
end

class Instruction
  attr_accessor :instruction, :param1, :param2

  def initialize(string)
    pattern = /(?<instruction>\w+) (?<param1>\w+)?( )?(?<param2>(\+|\-)?\w+)?/
    if match = pattern.match(string)
      @instruction = match[:instruction]
      @param1 = match[:param1]
      @param2 = match[:param2]
    end
  end

end

class Computer
  attr_accessor :instructions, :registers, :pc
  attr_accessor :waiting, :send_counter

  def initialize()
    @id = nil
    @registers = Hash.new
    @instructions = Instructions.new
    @pc = 0
  end

  def load(instructions)
    @instructions = instructions.dup
  end

  def set_registers(registers)
    registers.each { |r| @registers[r] = 0 }
  end

  # Executes instructions at current PC.
  def execute
    if @pc < 0 || @pc >= @instructions.length
      exit
    end

    # Load the next instruction from the PC location.
    instruction = @instructions[@pc]

    # This assumes that evaluating the instruction returns the number of multiplications.
    pc, multiplications = eval("%s('%s','%s')" % [instruction.instruction, instruction.param1, instruction.param2])
  end

  def set(p1, p2)
    @registers[p1] = @registers[p2] ? @registers[p2] : p2.to_i
    @pc += 1
    [@pc, 0]
  end

  def sub(p1, p2)
    @registers[p1] -= @registers[p2] ? @registers[p2] : p2.to_i
    @pc += 1
    [@pc, 0]
  end

  def mul(p1, p2)
    x = @registers[p1]
    y = @registers[p2] ? @registers[p2] : p2.to_i
    @registers[p1] = x * y
    @pc += 1
    [@pc, 1]
  end

  def jnz(p1, p2)
    test = @registers[p1] ? @registers[p1] : p1.to_i
    jump = @registers[p2] ? @registers[p2] : p2.to_i
    if test != 0
      @pc += jump
    else
      @pc += 1
    end
    [@pc, 0]
  end

end

# Load instructions.
instructions = Instructions.new
while line = gets
  instructions << Instruction.new(line)
end

# Boot computers.
computer = Computer.new()
computer.load(instructions)

computer.set_registers(%w(a b c d e f g h))

muls = 0
# Run programs.
while true
  pc, mul = computer.execute
  muls += mul
  break if pc < 0 || pc >= instructions.length
end
puts muls
