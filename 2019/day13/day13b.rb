# Read input line into program's instructions.
line = ARGF.readlines.first
program = Hash.new { |hash, key| hash[key] = 0 }
line.strip.split(",").map.with_index { |num, index| program[index] = num.to_i }

def address(program, position, mode, base)
  case mode
    when 0 then program[position]
    when 1 then position
    when 2 then program[position]+base
  end
end

def run(program, pc = 0, read_input, process_output)
  # Parameter modes:
  #   0: position mode, parameters are interpreted as position.
  #   1: immediate node, parameters are interpreted as value.
  #   2: relative mode, parameters are interpreted as relative position.

  # Set the starting relative base
  base = 0
  # Create a buffer for sending structured output.
  buffer = []

  while true do
    value = program[pc]
    opcode = ("%02s" % value)[-2,2].to_i  # Opcode is last two digits of first value.

    # Parameter mode are right to left in string, starting from third position from end.
    modes = ("%05s" % value)[0...-2].to_s.reverse.chars.map(&:to_i)

    first_address  = address(program, pc+1, modes[0], base)
    second_address = address(program, pc+2, modes[1], base)
    third_address  = address(program, pc+3, modes[2], base)

    case opcode
    when 1 then  # opcode 1: addition
      program[third_address] = program[first_address] + program[second_address]
      pc += 4
    when 2 then  # opcode 2: multiplication
      program[third_address] = program[first_address] * program[second_address]
      pc += 4
    when 3 then  # opcode 3: store
      input = read_input.call
      program[first_address] = input
      pc += 2
    when 4 then  # opcode 4: output
      buffer << program[first_address]
      # Flush output buffer to output_queue when there are three items.
      if buffer.length == 3
        process_output.call([buffer[0], buffer[1], buffer[2]])
        buffer = []
      end
      pc += 2
    when 5 then  # opcode 5: jump if true
      if program[first_address] != 0
        pc = program[second_address]
      else
        pc += 3
      end
    when 6 then  # opcode 6: jump if false
      if program[first_address] == 0
        pc = program[second_address]
      else
        pc += 3
      end
    when 7 then  # opcode 7: less than
      program[third_address] = (program[first_address] < program[second_address]) ? 1 : 0
      pc += 4
    when 8 then  # opcode 8: equals
      program[third_address] = (program[first_address] == program[second_address]) ? 1 : 0
      pc += 4
    when 9 then  # opcode 9: adjust relative base
      base += program[first_address]
      pc += 2
    when 99 then
      return
    end
  end
end

def find_ball()
  $screen.key(4)  # Find key (position) where value (id) in $screen is 4.
end

def find_paddle()
  $screen.key(3)  # Find key (position) where value (id) in $screen is 3.
end

def print_screen(screen, left_up, right_down)
  start_x, start_y = left_up
  max_x, max_y = right_down

  chars = [" ", "+", "#", "=", "*"]
  (start_y..max_y).each do |y|
    line = ""
    (start_x..max_x).each do |x|
      char = screen[ [x,y] ] || 0
      line += chars[ char ]
    end
    line += "\n"
    puts line
  end
end

# Determine next position of joystick, on request.
def next_position()
  # Get position of ball and paddle.
  ball = find_ball()
  paddle = find_paddle()

  return 0 if ball == nil || paddle == nil

  if paddle[0] < ball[0]  # Paddle is left of ball...
    input = 1             # ... so move right.
  elsif paddle[0] > ball[0]
    input = -1            # ... or move left.
  else
    input = 0             # ... or remain in neutral position.
  end
end

# Argh, use of global variables is to be frowned upon obviously.
$screen = {}
$score = 0
$dimensions = [0,0]  # Current size of screen; will be updated dynamically.

def update_screen(output)
  left_up = [0,0]

  output.each_slice(3) do |x,y,id|
    if x == -1 && y == 0
      $score = id
    else
      $screen[ [x,y] ] = id
      $dimensions[0] = (x > $dimensions[0]) ? x : $dimensions[0]
      $dimensions[1] = (y > $dimensions[1]) ? y : $dimensions[1]
    end
  end

  # Strangely, [0,0] isn't registered, so make that a wall too.
  $screen[ [0,0] ] = 1

  # print_screen($screen, left_up, $dimensions)
  # puts "score: %i\n" % [$score]
end

program[0] = 2  # Play for free; insert two quarters.
pc = 0

# Run game console, with queues for commands (input) and screen updates.
run(program, pc, lambda { next_position } , lambda { |output| update_screen(output) })

# Print score.
puts $score
