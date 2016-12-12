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

  def initialize
    @registers = Hash.new
    @instructions = Instructions.new
    @pc = 0
  end

  def load(instructions)
    @instructions = instructions
  end

  def registers=(registers)
    registers.each { |r| @registers[r] = 0 }
    # For second part of day 12, uncomment next line.
    # @registers["c"] = 1
  end

  # Executes instructions at current PC.
  def execute
    # Load the next instruction from the PC location.
    instruction = @instructions[@pc]

    # This assumes that evaluating the instruction returns the PC.
    @pc = eval("%s('%s','%s')" % [instruction.instruction, instruction.param1, instruction.param2])
  end

  def cpy(p1, p2)
    @registers[p2] = @registers[p1] ? @registers[p1] : p1.to_i
    @pc += 1
  end

  def inc(p1, p2)  # p2 isn't used.
    @registers[p1] += 1
    @pc += 1
  end

  def dec(p1, p2)  # p2 isn't used.
    @registers[p1] -= 1
    @pc += 1
  end

  def jnz(p1, p2)
    if @registers[p1] != 0
      @pc += p2.to_i
    else
      @pc += 1
    end
  end
end

# Load instructions.
instructions = Instructions.new
while line = gets
  instructions << Instruction.new(line)
end

# Boot computer.
computer = Computer.new
computer.load(instructions)
computer.registers = ["a", "b", "c", "d"]

# Run program.
pc = 0
while true
  pc = computer.execute
  break if not pc.between?(0, instructions.length-1)
end

puts computer.registers["a"]
