def caught?(layers, delay)
  # TODO Find situation in which all layers are at zero at starting time + layer.
  # Or... for a given delay, just count the number of scanners at the zeroth position.
  # That would save the iterations, increasing the time / position and investigating
  # the next layer.
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
      end
    end

    # No need to test the other positions.
    break if caught

    time += 1
    position += 1
  end

  caught
end

# Read input.
layers = {}
while line = gets
  depth, range = line.split(": ").map(&:to_i)
  layers[depth] = range
end

# Find out if we're being caught for range of delays.
delay = 0
while caught?(layers, delay)
  delay += 1
end
puts delay