target = 36000000

def visiting_elves(house)
  factors = []
  max = Math.sqrt(house)
  1.upto(max) do |f|
    factors.concat([f,house/f]) if house % f == 0
  end
  factors.uniq
end

house = 0
number_of_presents = 0
until number_of_presents >= target
  house += 1
  number_of_presents = 0

  elves = visiting_elves(house)
  elves.each do |elf|
    number_of_presents += elf * 10
  end
end

puts house
