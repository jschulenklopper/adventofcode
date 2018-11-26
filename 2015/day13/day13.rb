class Member
  attr_reader :name
  attr_reader :preferences

  def initialize(name)
    @name = name
    @preferences = Hash.new
  end

  def set_preference(neighbor, happiness)
    @preferences[neighbor] = happiness
  end
  
  def to_s
    @name
  end
end

class Family < Array
  def add_or_find(name)
    if member = self.find { |member| member.name == name }
      return member
    else
      member = Member.new(name)
      self << member
      return member
    end
  end
end

family = Family.new

# Assemble family from input file, and register the happiness scores.
while line = gets
  line_pattern = /(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)./
  member_name = line_pattern.match(line)[1]
  happiness = line_pattern.match(line)[3].to_i * (line_pattern.match(line)[2] == "lose" ? -1 : 1)
  neighbor_name = line_pattern.match(line)[4]

  member = family.add_or_find(member_name)
  neighbor = family.add_or_find(neighbor_name)
  member.set_preference(neighbor, happiness)
end

max_happiness = 0

# Generate possible seatings by permutations of the family list.
# Remove one from the family, and put it on beginning and end of seating.
# Pinning one family member to a fixed seat (first one) reduces the
# number of identical seatings around a round table.
first = family.shift
family.permutation.each do | seating |
  seating.unshift(first)
  seating.push(first)

  happiness = 0

  # Compute happiness score of this seating.
  seating.each_index do | index |
    if index < seating.length - 1
      member, neighbor = seating[index], seating[index+1]
      happiness += member.preferences[neighbor] + neighbor.preferences[member]
    end
  end

  max_happiness = happiness if happiness > max_happiness
end

puts max_happiness