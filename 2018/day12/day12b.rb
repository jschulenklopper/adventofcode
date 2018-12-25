# Read starting state: row of pots.
line = gets.match(/^initial state: ([#.]+)/).captures.first.chars
state = line.map.with_index { |c, i| i if c == "#"}.compact

# Read all the transformation rules.
notes = []
while line = gets
  next if line.strip.empty?
  temp_from, temp_to = line.match(/^(.{5}) =\> (.)$/).captures
  from = temp_from.chars.map.with_index { |c,i| i-2 if c == "#" }
  to = (temp_to == "#") ? 0 : nil
  notes << [from, to]
end

# Applies all notes on current state returning new state.
def apply_notes(notes, state)
  new_state = []

  # For all positions...
  (state.min-2 .. state.max+2).each do |value|
    # ... apply all the rules.
    notes.each do |from, to|
      # Build values from note that should be in state.
      required_from = (value-2 .. value+2).each.map.with_index { |v, i| (from[i]) ? v : nil }
      # Build list of values is state.
      in_state = (value-2 .. value+2).each.map { |s| (state.include?(s)) ? s : nil }

      if required_from == in_state
        if to
          new_state << value
        end
      end
    end
  end

  new_state.sort
end

start = state.sum
INTERMEDIATE = 100

# First, try 1000 iterations.
(1 .. INTERMEDIATE).each do |time|
  state = apply_notes(notes, state)
end

after_int = state.sum

state = apply_notes(notes, state)
after_next = state.sum

difference = after_next - after_int

puts difference * (50000000000-INTERMEDIATE) + after_int