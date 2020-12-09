# Read input line into program's instructions.
program = ARGF.readlines.map { |line|
  instruction = line.strip.split
  # [operation, argument]
  [instruction[0], instruction[1].to_i]
}

# Run one instruction of program.
# TODO Alternatively, make a separate function to run whole program,
# although manipulation or inspection at run-time is more difficult.
def run(program, pc, acc)
  puts "run(program, %i, %i)" % [pc, acc]
  operation, argument = program[pc]

  p [operation, argument]

  case operation
  when "acc"
    acc += argument
    pc += 1
  when "jmp"
    pc += argument
  when "nop"
    pc += 1
  end
  
  [pc, acc]
end

# Set up context for program to run.
pc = 0
accumulator = 0

# Set up variables to notice if we're in a loop.
in_loop = false
seen = Array.new

while not in_loop do
  pc, accumulator = run(program, pc, accumulator)
  # Exit loop if we've seen pc before.
  if seen.include?(pc)
    puts accumulator
    break
  end
  seen << pc
end

