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

  def to_s
    if @param2
      @instruction + " " + @param1 + " " + @param2
    else
      @instruction + " " + @param1
    end
  end
end

class Computer
  attr_accessor :instructions, :registers, :pc
  attr_accessor :sound

  def initialize
    @registers = Hash.new
    @instructions = Instructions.new
    @pc = 0
    @sound = 0
  end

  def load(instructions)
    @instructions = instructions
  end

  def registers=(registers)
    registers.each { |r| @registers[r] = 0 }
  end

  def register?(string)
    return @registers[string] != nil
  end

  # Executes instructions at current PC.
  def execute
    # Load the next instruction from the PC location.
    instruction = @instructions[@pc]

    # This assumes that evaluating the instruction returns the PC.
    @pc = eval("%s('%s','%s')" % [instruction.instruction, instruction.param1, instruction.param2])
  end

  def snd(p1, p2) # p2 not used.
    @sound = @registers[p1] ? @registers[p1] : p1.to_i
    @pc += 1
  end

  def set(p1, p2)
    @registers[p1] = @registers[p2] ? @registers[p2] : p2.to_i
    @pc += 1
  end

  def add(p1, p2)
    @registers[p1] += @registers[p2] ? @registers[p2] : p2.to_i
    @pc += 1
  end

  def mul(p1, p2)
    x = @registers[p1]
    y = @registers[p2] ? @registers[p2] : p2.to_i
    @registers[p1] = x * y
    @pc += 1
  end

  def mod(p1, p2)
    x = @registers[p1]
    y = @registers[p2] ? @registers[p2] : p2.to_i
    @registers[p1] = x % y
    @pc += 1
  end

  def rcv(p1, p2) # p2 not used.
    recover = @registers[p1] ? @registers[p1] != 0 : p1.to_i != 0
    if recover
      puts @sound
      exit  
    end
    @pc += 1
  end

  def jgz(p1, p2)
    test = @registers[p1] ? @registers[p1] : p1.to_i
    jump = @registers[p2] ? @registers[p2] : p2.to_i
    if test > 0
      @pc += jump
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
# FIXME Instead of declaring them in advance, discover them at runtime.
computer.registers = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)

# Run program.
pc = 0
while true
  pc = computer.execute
  break if not pc.between?(0, instructions.length-1)
end