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
    # For second part of day 12, uncomment next line.
    # @registers["c"] = 1
  end

  # Executes instructions at current PC.
  def execute
    # Load the next instruction from the PC location.
    instruction = @instructions[@pc]
    
    puts "execute: %s('%s','%s')" % [instruction.instruction, instruction.param1, instruction.param2]

    # This assumes that evaluating the instruction returns the PC.
    @pc = eval("%s('%s','%s')" % [instruction.instruction, instruction.param1, instruction.param2])
  end

  def tgl(p1, p2)  # p2 isn't used.
    new_instructions = { "cpy" => "jnz", "jnz" => "cpy",  # Two-argument instructions.
                         "inc" => "dec", "dec" => "inc",  # One-argument instructions.
                         "tgl" => "inc" }
  
    location = @pc + @registers[p1]
    if ! location.between?(0, @instructions.length - 1)
      return @pc += 1
    end

    # Get new instruction.
    current_instruction = @instructions[location]
    new_instruction = new_instructions[current_instruction.instruction]

    # Change instruction.
    @instructions[location].instruction = new_instruction
    @pc += 1
  end

  def cpy(p1, p2)
    return if ! @registers[p2]
    @registers[p2] = @registers[p1] ? @registers[p1] : p1.to_i
    @pc += 1
  end

  def inc(p1, p2)  # p2 isn't used. TODO Make it optional parameter.
    return if ! @registers[p1]
    @registers[p1] += 1
    @pc += 1
  end

  def dec(p1, p2)  # p2 isn't used.
    return if ! @registers[p1]
    @registers[p1] -= 1
    @pc += 1
  end

  def jnz(p1, p2)  # TODO This one could break, with p2 being a register instead of int.
    if @registers[p1] != 0
      @pc += @registers[p2] ? @registers[p2] : p2.to_i 
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

computer.registers["a"] = 7

# Run program.
pc = 0
while true
  puts "---"
  puts "pc: %d" % pc
  puts "registers:\n" + computer.registers.map { |r| " " + r.to_s + ": " + computer.registers[r].to_s + "\n" }.join
  puts "instructions:\n" + computer.instructions.map { |i| " " + i.inspect + "\n" }.join
  puts
  pc = computer.execute

  break if !pc
  puts
  puts "new pc: %d" % pc
  break if not pc.between?(0, instructions.length-1)
end

puts computer.registers["a"]
