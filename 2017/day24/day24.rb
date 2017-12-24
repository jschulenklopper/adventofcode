# Collect all valid bridges of components, starting at start.
def bridges(start, components)
  bridges = []
  return bridges if components.empty?

  # Find all potential first components.
  firsts = components.select { |c| c[0] == start || c[1] == start }

  # For all potential first components...
  firsts.each { |first|
    # ... add first component to bridge... 
    bridges << [first]

    # ... and find collection of connecting bridges
    # (with first component removed from collection).
    new_start = ( first[0] == start ) ? first[1] : first[0]
    rests = bridges(new_start, components.reject { |c| c == first } )

    # Construct the possible new bridges.
    rests.each { | rest |
      bridges << [first] + rest
    }
  }
  bridges
end

def max_length_strength(bridges)
  # Construct list of lengths and strengths.
  length_strengths = bridges.map { |bridge| [bridge.length, strength(bridge)] }
  # Find the maximum length.
  max_length = length_strengths.map(&:first).max
  # Find the maximum strength of a bridge with that length.
  length_strengths.select {|b| b[0] == max_length }.map(&:last).max
end

def max_strength(bridges)
  bridges.map { |bridge| strength(bridge) }.max
end

def strength(bridge)
  bridge.reduce(0) { |strength, component| strength += component.reduce(&:+) }
end

def main(file)
  components = []
  lines = File.open(file).readlines.map(&:chomp)
  components = lines.map { |line| line.split("/").map(&:to_i) }

  bridges = bridges(0, components)

  # Return max strength, and strength of bridge with maximum length.
  [max_strength(bridges), max_length_strength(bridges)]
end

if __FILE__ == $0
  puts main(ARGV[0])
end

