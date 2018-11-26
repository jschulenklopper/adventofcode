class Circle < Array
  # Get index of next item in circle.
  def next(current) 
    new = (current >= self.length-1) ? 0 : current+1
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
  neighbor = elves.next(elf)  # Index of neighbor.

  elves[elf][1] += elves[neighbor][1]  # Elf gets all gifts from neighbor.
  elves[neighbor][1] = 0

  elves.delete_at(neighbor)  # Delete elf from circle.
  
  elf = elves.next(elf)
end

puts elves