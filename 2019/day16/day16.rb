signal = ARGF.readline.strip.chars.map(&:to_i)

PATTERN = [0, 1, 0, -1]
PHASES = 100

PHASES.times do |i|
  next_signal = []

  # Process signal.
  # TOFIX This is terribly slow.
  signal.each.with_index do |number, i|
    # Calculate pattern for this number.
    pattern = []
    PATTERN.each { |p| pattern << [p] * (i+1) }
    pattern.flatten!
    pattern = pattern * ((signal.length))

    # Remove first item and crop pattern to sufficient length.
    pattern = pattern[1, signal.length]

    next_signal[i] = signal.zip(pattern).map{|x, y| x * y}.sum.abs % 10
  end

  signal = next_signal
end

puts signal[0,8].join