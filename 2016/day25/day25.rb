class Instructions < Array
end

class Instruction
  attr_accessor :instruction, :param1, :param2

  def initialize(string)
    pattern = /(?<instruction>\w+) (?<param1>(\+|\-)?\w+)?( )?(?<param2>(\+|\-)?\w+)?/
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
  end

  # Executes instructions at current PC.
  def execute
    # Load the next instruction from the PC location.
    instruction = @instructions[@pc]
    
    # This assumes that evaluating the instruction returns the PC.
    result = eval("%s('%s','%s')" % [instruction.instruction, instruction.param1, instruction.param2])
    [result[0], result[1]]  # [@pc, out]
  end

  def out(p1, p2)
    output_value = @registers[p1] ? @registers[p1] : p1.to_i
    @pc += 1
    [@pc, output_value]
  end

  def cpy(p1, p2)
    # return if ! @registers[p2]
    @registers[p2] = @registers[p1] ? @registers[p1] : p1.to_i
    @pc += 1
    [@pc, nil]
  end

  def inc(p1, p2)  # p2 isn't used. TODO Make it optional parameter.
    # return if ! @registers[p1]
    @registers[p1] += 1
    @pc += 1
    [@pc, nil]
  end

  def dec(p1, p2)  # p2 isn't used.
    # return if ! @registers[p1]
    @registers[p1] -= 1
    @pc += 1
    [@pc, nil]
  end

  def jnz(p1, p2)  # TODO This one could break, with p2 being a register instead of int.
    if @registers[p1] && @registers[p1].to_i != 0
      @pc += @registers[p2] ? @registers[p2] : p2.to_i 
    elsif ! @registers[p1] && p1 != 0 && p1 != '0'
      @pc += @registers[p2] ? @registers[p2] : p2.to_i 
    else
      @pc += 1
    end
    [@pc, nil]
  end
end

def next_expected_digit(last)
  (last == 1 || last == nil) ? 0 : 1
end

# Load instructions.
instructions = Instructions.new
while line = gets
  instructions << Instruction.new(line)
end

next_a = 0

while next_a <= 1000  # Maximum number for a to try.
  # Initialize loop.
  pattern = ""
  last_out = 1  # Simulate last digit as 1, so that next digit (and pattern) starts with 0.

  # Boot computer.
  computer = Computer.new
  computer.load(instructions)
  computer.registers = ["a", "b", "c", "d"]
  computer.registers["a"] = next_a  # Load next_a into register for a.

  # Run program.
  pc = 0

  until pattern.length >= 16
    result = computer.execute
    pc = result[0]
    out = result[1]

    break if not pc.between?(0, instructions.length-1)  # Apparently invalid setup, so next a.

    next if out == nil

    if out == next_expected_digit(last_out)
      # This is going all right (so far).
      pattern << out.to_s
      last_out = out
    else
      # Apparently, we've seen other output than expected, so next a.
      pattern = ""
      break
    end
  end
  
  if pattern.length >= 16
    puts next_a
    exit
  end

  next_a += 1
end