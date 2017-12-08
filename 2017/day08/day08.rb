registers = Hash.new(0)
largest = 0

while instruction = gets
  instruction.match(/(?<reg>\w+)\s(?<op>\w+)\s(?<value>(\w|-)+)\sif\s(?<var>\w+)\s(?<rest>.+)/) do |match|
    # Transform instruction into valid Ruby expression using `registers` hash.
    register = "registers['%s']" % match[:reg]
    operator = match[:op] == "inc" ? "+=" : "-="
    value = match[:value]
    var = "registers['%s']" % match[:var]
    rest = match[:rest]

    # Rebuild instruction.
    instr = "%s %s %s if %s %s" % [register, operator, value, var, rest]

    # Evaluate instruction and store largest, if a new value.
    result = eval(instr)
    largest = result if result && result > largest
  end
end

puts "Highest at the end: %s" % registers.values.max
puts "Highest ever: %s" % largest
