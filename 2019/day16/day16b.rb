signal = ARGF.readline.strip.chars.map(&:to_i) * 10000
offset = signal[0,7].join.to_i
signal = signal[offset..-1]

PATTERN = [0, 1, 0, -1]
# Current offset of current input lands in generated pattern of just 1's,
# so pattern isn't really used; it's all adding 'till the end.

PHASES = 100

PHASES.times do |i|
  # Process signal, just adding all numbers, from the end to begin.
  (0..(signal.length-2)).reverse_each do |n|
    signal[n] = (signal[n] + signal[n+1]) % 10
  end
end

puts signal[0,8].join