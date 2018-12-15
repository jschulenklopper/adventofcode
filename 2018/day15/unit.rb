Unit = Struct.new(:type, :square, :ap, :hp, :alive)

class Unit
  def to_s
    t = (type == :elf) ? "E" : "G"
    "%s: %s (%i)" % [t, square.to_s, hp]
  end

  def char
    (type == :elf) ? "E" : "G"
  end

  def distance(unit)
    square.distance(unit.square)
  end

  def <=>(other)
    square <=> other.square
  end
end