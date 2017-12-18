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
    @queue = nil
    @waiting = false
    @send_counter = 0
  end

  def init(id)
    @id = id
    @registers['p'] = id
  end

  def load(instructions)
    @instructions = instructions.dup
  end

  def set_registers(registers)
    registers.each { |r| @registers[r] = 0 }
  end

  def register_queue(queue)
    @queue = queue
  end

  # Executes instructions at current PC.
  def execute
    # Load the next instruction from the PC location.
    instruction = @instructions[@pc]

    # Set status to not waiting.
    @waiting = false

    # This assumes that evaluating the instruction might return a message.
    message = eval("%s('%s','%s')" % [instruction.instruction, instruction.param1, instruction.param2])
  end

  def snd(p1, p2) # p2 not used.
    message = @registers[p1] ? @registers[p1] : p1.to_i
    @pc += 1
    @send_counter += 1
    message
  end

  def rcv(p1, p2) # p2 not used.
    if ! @queue.empty?
      message = @queue.shift
      @registers[p1] = message
      @pc += 1
    else
      @waiting = true
    end
    nil # No message to return
  end

  def set(p1, p2)
    @registers[p1] = @registers[p2] ? @registers[p2] : p2.to_i
    @pc += 1
    nil # No message to return
  end

  def add(p1, p2)
    @registers[p1] += @registers[p2] ? @registers[p2] : p2.to_i
    @pc += 1
    nil # No message to return
  end

  def mul(p1, p2)
    x = @registers[p1]
    y = @registers[p2] ? @registers[p2] : p2.to_i
    @registers[p1] = x * y
    @pc += 1
    nil # No message to return
  end

  def mod(p1, p2)
    x = @registers[p1]
    y = @registers[p2] ? @registers[p2] : p2.to_i
    @registers[p1] = x % y
    @pc += 1
    nil # No message to return
  end


  def jgz(p1, p2)
    test = @registers[p1] ? @registers[p1] : p1.to_i
    jump = @registers[p2] ? @registers[p2] : p2.to_i
    if test > 0
      @pc += jump
    else
      @pc += 1
    end
    nil
  end

end

# Load instructions.
instructions = Instructions.new
while line = gets
  instructions << Instruction.new(line)
end

# Boot computers.
computer0 = Computer.new()
computer0.load(instructions)
computer1 = Computer.new()
computer1.load(instructions)

# FIXME Instead of declaring them in advance, discover them at runtime.
computer0.set_registers(%w(a b c d e f g h i j k l m n o p q r s t u v w x y z))
computer1.set_registers(%w(a b c d e f g h i j k l m n o p q r s t u v w x y z))

# Initialize computers with their program ID: 0 and 1.
# This also sets register `p` to that value.
computer0.init(0)
computer1.init(1)

from0to1 = Array.new
from1to0 = Array.new
computer0.register_queue(from1to0)
computer1.register_queue(from0to1)

# Run programs.
while true
  message_for_1 = computer0.execute
  from0to1.push(message_for_1) if message_for_1

  message_for_0 = computer1.execute
  from1to0.push(message_for_0) if message_for_0

  if computer0.waiting && computer1.waiting
    break
  end
end

puts computer1.send_counter
