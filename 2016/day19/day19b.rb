class Circle < Array
  # Get next neighbor.
  def next(current) 
    current = (current + 1) % self.length
  end

  # Get index of item across in circle.
  def across(current) 
    circle_length = (self.length / 2).floor
    current = (current + circle_length) % self.length
  end
end

number = gets.strip.to_i

elves = Circle.new

elf = 1  # Number of current elf.
while elf <= number
  elves << [elf,1]  # [Elf number, number of gifts]
  elf += 1
end

elf = 0  # Index of current elf.

while elves.length > 1
  across = elves.across(elf)  # Index of neighbor.

  elves[elf][1] += elves[across][1]  # Elf gets all gifts from neighbor.
  elves.delete_at(across)

  elf -= 1 if elf > across 
  elf = elves.next(elf)
end

p elves
