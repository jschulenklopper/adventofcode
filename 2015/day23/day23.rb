class Instructions < Array
end

class Instruction
  attr_accessor :instruction, :register, :offset

  def initialize(string)
    pattern = /(?<instruction>\w+) (?<register>\w+)?(, )?(?<offset>(\+|\-)\d+)?/
    if match = pattern.match(string)
      @instruction = match[:instruction]
      @register = match[:register]
      @offset = match[:offset]
    end
  end

  def to_s
    "%s %s %s" % [@instruction, @register, @offset]
  end
end

class Computer
  attr_accessor :instructions, :registers, :pc

  def initialize
    @registers = Hash.new
    @instructions = Array.new
    @pc = 0
  end

  def load(instructions)
    @instructions = instructions
  end

  def registers=(registers)
    registers.each { |reg| @registers[reg] = 0 }
    # For second part of day 23, uncomment next line.
    # @registers["a"] = 1
  end

  # Executes instructions at current PC.
  def execute
    instruction = @instructions[pc]

    eval("%s('%s',%s)" % [instruction.instruction, instruction.register, instruction.offset])
  end

  def hlf(r)
    @registers[r] = @registers[r] / 2
    @pc += 1
  end

  def tpl(r)
    @registers[r] = @registers[r] * 3
    @pc += 1
  end

  def inc(r)
    @registers[r] += 1
    @pc += 1
  end

  def jmp(r, offset)
    @pc += offset
  end

  def jie(r, offset)
    if @registers[r] % 2 == 0
      @pc += offset
    else
      @pc += 1
    end
  end

  def jio(r, offset)
    if @registers[r] == 1
      @pc += offset
    else
      @pc += 1
    end
  end
end

instructions = Instructions.new

while line = gets
  instructions << Instruction.new(line)
end

computer = Computer.new
computer.load(instructions)
computer.registers = ["a", "b"]

pc = 0
while true
  pc = computer.execute 
  break if not (0..instructions.length-1).include?(pc)
end

puts computer.registers["b"]