class String
  def is_integer?
    true if Integer(self) rescue false
  end
end

class Instructions < Array
end 

class Instruction
  attr_reader :operation, :in_1, :in_2, :out
  
  def Instruction.parse(string)
    pattern = /(.+) \-\> (\w+)/

    @operation, @in_1, @in_2 = Instruction.parse_left(pattern.match(string)[1])
    @out = Instruction.parse_right(pattern.match(string)[2])

    Instruction.new(@operation, @in_1, @in_2, @out)
  end

  def Instruction.parse_right(string)
    string
  end

  def Instruction.value_or_wire(string)
    string.is_integer? ? string.to_i : string
  end

  def Instruction.parse_left(string)
    biop_pattern = /(.+) (AND|OR|LSHIFT|RSHIFT) (.+)/
    uniop_pattern = /(NOT) (.+)/
    nop_pattern = /(\w+)/

    if string =~ biop_pattern
      op = biop_pattern.match(string)[2]
      in_1 = Instruction.value_or_wire(biop_pattern.match(string)[1])
      in_2 = Instruction.value_or_wire(biop_pattern.match(string)[3])
    elsif string =~ uniop_pattern
      op = uniop_pattern.match(string)[1]
      in_1 = Instruction.value_or_wire(uniop_pattern.match(string)[2])
      in_2 = nil
    elsif string =~ nop_pattern
      op = nil
      in_1 = Instruction.value_or_wire(nop_pattern.match(string)[1])
      in_2 = nil
    end

    [op, in_1, in_2]
  end
  
  def initialize(operation, in_1, in_2, out)
    @operation = operation
    @in_1 = in_1
    @in_2 = in_2
    @out = out
  end
end

class Operation
  attr_writer :op
  
  def not(in_1)
  end

  def or(in_1, in_2)
  end

  def and(in_1, in_2)
  end

  def rshift(in_1, in_2)
  end

  def lshift(in_1, in_2)
  end
end

instructions = Instructions.new;

# Parse the wiring instructions
while line = gets
  puts line
  instructions << Instruction.parse(line)
end

puts "---\nNumber of instructions: %d" % [instructions.length]
