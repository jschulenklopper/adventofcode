class String
  def is_integer?
    true if Integer(self) rescue false
  end
end

class Instruction
  attr_reader :operation, :in_1, :in_2, :out
  
  def to_s
    puts "%s %s %s -> %s" % [@in_1, @operation, @in_2, @out]
  end

  def Instruction.parse(string)
    left = /(.+) \-\>/.match(string)[1]
    op, in_1, in_2 = Instruction.parse_left(left)
    @operation = op # ? Operation.new(op) : nil
    @in_1 = (in_1 && in_1.is_integer?) ? in_1.to_i : (in_1 ? Wire.new(in_1) : nil)
    @in_2 = (in_2 && in_2.is_integer?) ? in_2.to_i : (in_2 ? Wire.new(in_2) : nil)

    right = /\-\> (\w+)/.match(string)[1]
    out = Instruction.parse_right(right)

    Instruction.new(@operation, @in_1, @in_2, @out)
  end

  def Instruction.parse_right(string)
    @out = Wire.new(string)
  end

  def Instruction.parse_left(string)
    biop_string = /(.+) (AND|OR|LSHIFT|RSHIFT) (.+)/
    uniop_string = /(NOT) (.+)/
    nop_string = /(\w+)/

    if string =~ biop_string
      op = biop_string.match(string)[2]
      in_1 = biop_string.match(string)[1]
      in_2 = biop_string.match(string)[3]
    elsif string =~ uniop_string
      op = uniop_string.match(string)[1]
      in_1 = uniop_string.match(string)[2]
      in_2 = nil
    elsif string =~ nop_string
      op, in_2 = "assign", nil
      in_1 = nop_string.match(string)[1]
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
  attr_reader :op

  def to_s
    @op.to_s
  end 

  def initialize(op)
    if %w(OR LSHIFT RSHIFT AND NOT).include?(op)
      @op = op.downcase
    else
      @op = "assign"
    end
  end
  
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

class Value
  attr_reader :value

  def Value.is_value?(string)
    return false if string =~ /[a-z]/
    true
  end

  def initialize(value)
    @value = value
  end
end

class Wire
  attr_reader :id
  attr_writer :signal

  def initialize(id)
    @id = id
  end
end

wires = [];
instructions = [];

# Parse the wiring instructions
while line = gets
  puts line
  instructions << Instruction.parse(line)
  p instructions.last
  puts 
end
 
puts instructions.length
