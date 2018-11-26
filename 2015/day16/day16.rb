aunts = Hash.new
pattern = /\w+ (\d+): (.*)/

while line = gets
  match = pattern.match(line)
  number = match[1].to_i
  attributes = match[2].split(", ")

  attribute_list = Hash.new

  attributes.each do |attribute|
    key, value = attribute.split(": ")[0,2]
    attribute_list[key.to_sym] = value.to_i
  end
  aunts[number] = attribute_list
end

analysis = {children: 3,
            cats: 7,
            samoyeds: 2,
            pomeranians: 3,
            akitas: 0,
            vizslas: 0,
            goldfish: 5,
            trees: 3,
            cars: 2,
            perfumes: 1 }

matching_aunts = aunts.select do |aunt, attributes|
  match = true
  analysis.each do |key, value|
    if attributes[key] && attributes[key] != value
      match = false
    end
  end
  match
end

puts matching_aunts.keys.first