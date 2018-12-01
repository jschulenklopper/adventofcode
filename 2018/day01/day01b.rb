freq = 0
freqs = []

# Get all input, split at newlines, convert to integers,
# and then cycle through that array indefinitely.
gets(nil).split.map(&:to_i).cycle do |d|
  freq += d                      # Adjust frequence.
  break if freqs.include?(freq)  # Break if seen before.
  freqs << freq                  # Add frequency to the list.
end

puts freq