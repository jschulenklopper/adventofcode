Square = Struct.new(:x, :y)

class Square
  def to_s
    "[%i,%i]" % [x, y]
  end

  def char
    "."
  end

  def distance(square)
    (x - square.x).abs + (y - square.y).abs
  end

  def <=>(other)
    comp = (y <=> other.y)
    (!comp.zero?) ? comp : x <=> other.x
  end
end