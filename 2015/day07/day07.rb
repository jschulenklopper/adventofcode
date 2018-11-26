class String
  def is_integer?
    true if Integer(self) rescue false
  end
end

class Instructions < Array
  def initialize
    @storage = Hash.new
    # For second part of puzzle, enable next line.
    # @storage["b"] = 16076
  end

  def storage
    @storage
  end

  def value(wire)
    # Direct integer.
    if wire.class == Integer || wire.class == Fixnum
      return wire
    end
    # String but with integer value.
    if wire.is_integer? 
      return wire.to_i
    end
    # Previously stored value.
    if @storage[wire]
      return @storage[wire]
    end
    # OK, so we need to compute the value...
    instruction = self.find { |instr| instr.out == wire }
    op = instruction.operation
    in_1 = value(instruction.in_1)
    in_2 = value(instruction.in_2) if instruction.in_2
    # ... and also store the result.
    @storage[wire] = eval("Instruction.%s(%s,%s)" % [op, in_1, in_2])
  end
end 

class Instruction
  attr_reader :operation, :in_1, :in_2, :out
  
  def initialize(string)
    pattern = /(.+) \-\> (\w+)/

    @operation, @in_1, @in_2 = Instruction.parse_left(pattern.match(string)[1])
    @out = pattern.match(string)[2]
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
      op = "ASSIGN"
      in_1 = Instruction.value_or_wire(nop_pattern.match(string)[1])
      in_2 = nil
    end

    [op, in_1, in_2]
  end
  
  def Instruction.ASSIGN(in_1, *in_2)
    in_1
  end

  def Instruction.NOT(in_1, *in_2)
    ~in_1
  end

  def Instruction.OR(in_1, in_2)
    in_1 | in_2
  end

  def Instruction.AND(in_1, in_2)
    in_1 & in_2
  end

  def Instruction.RSHIFT(in_1, in_2)
    in_1 >> in_2
  end

  def Instruction.LSHIFT(in_1, in_2)
    in_1 << in_2
  end
end

instructions = Instructions.new;

# Parse the wiring instructions
while line = gets
  instructions << Instruction.new(line)
end

# Compute value of requested wire.
puts instructions.value("a")