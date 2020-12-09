# Read input line into program's instructions.
program = ARGF.readlines.map { |line|
  instruction = line.strip.split
  # [operation, argument]
  [instruction[0], instruction[1].to_i]
}

# Run one instruction of program, return [program counter, accumulator].
def run_instruction(program, pc, acc)
  operation, argument = program[pc]

  case operation
    when "acc" then acc += argument; pc += 1
    when "jmp" then pc += argument
    when "nop" then pc += 1
  end
  
  [pc, acc]
end

# Run complete program, return [accumulator, exit code].
def run(program)
  # Set up context.
  pc = 0
  acc = 0

  # Set up variable to notice if we're in a loop.
  seen = []

  while pc.between?(0,program.length - 1) do
    pc, acc = run_instruction(program, pc, acc)
    if seen.include? pc
      pc = -1  # Invalid value to halt program.
    end
    seen << pc
  end
  
  exit_code = pc == -1 ? -1 : 0
  [acc, exit_code]
end

# Generate list of mutated programs.
def mutates(program)
  programs = []

  # Maximum number of mutations is number of instructions.
  program.length.times do |i|
    # Make a deep dup of program. FIXME This is ugly.
    prgm = program.dup.map(&:clone)
    # Make mutation of instruction at i.
    if prgm[i][0] == "nop"
      prgm[i][0] = "jmp"
    elsif prgm[i][0] == "jmp"
      prgm[i][0] = "nop"
    else
      next
    end
    # Add mutated program to list of mutations.
    programs << prgm 
  end
  programs
end

puts "part 1"

acc, exit_code = run(program.dup)
puts acc

puts "part 2"

# Run all program mutations.
mutates(program).each do |program|
  acc, exit_code = run(program)
  puts acc if exit_code == 0
end
