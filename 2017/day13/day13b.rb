def calc_severity(layers, delay)
  severity = 0
  time = delay
  position = 0
  caught = false

  until position > layers.keys.max
    if layers.has_key?(position)
      # There's a scanner at this layer... so compute its position.
      range = layers[position] - 1
      scanner_position =  range - (time % (2 * range) - range).abs

      # If scanner is at position 0...
      if scanner_position == 0
        caught = true
        # ... add damage to severity.
        severity += position * layers[position]
      end
    end

    time += 1
    position += 1
  end

  return [caught, severity]
end

# Read input.
layers = {}
while line = gets
  depth, range = line.split(": ").map(&:to_i)
  layers[depth] = range
end

# Calculate severity for range of delays.
delay = 0
while true
  caught, severity = calc_severity(layers, delay)
  if severity == 0 && caught == false
    puts delay
    exit
  end

  delay += 1
end
