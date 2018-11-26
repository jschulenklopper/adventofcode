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

analysis = {children: lambda { |v| v == 3},
            cats: lambda { |v| v  > 7},
            samoyeds: lambda { |v| v == 2},
            pomeranians: lambda { |v| v < 3},
            akitas: lambda { |v| v == 0},
            vizslas: lambda { |v| v == 0},
            goldfish: lambda { |v| v < 5},
            trees: lambda { |v| v > 3},
            cars: lambda { |v| v == 2},
            perfumes: lambda { |v| v == 1 }}

matching_aunts = aunts.select do |aunt, attributes|
  match = true
  analysis.each do |key, f|
    if attributes[key] && ! f.call(attributes[key])
      match = false
    end
  end
  match
end

puts matching_aunts.keys.first