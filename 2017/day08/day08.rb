registers = []
largest = 0

# There's an ugly hack here, in that all registers are stored in the global
# scope, and as a global variable. :scream: FIXME

while instruction = gets
  instruction.match(/^(?<reg>\w+)\s(?<op>\w+)\s(?<value>.*)\sif\s(?<cond>(?<var>\w+).*)/) do |match|
    register = "$" + match[:reg]
    operator = match[:op] == "inc" ? "+=" : "-="
    value = match[:value].to_i
    cond = match[:cond]
    var = "$" + match[:var]

    instr = "%s %s %s" % [register, operator, value]

    eval("%s ||= 0" % register)
    eval("%s ||= 0" % var)

    execute = eval("$%s" % cond) # UGLY, because of the "$" before the variable in the condition.

    if execute
      result = eval("%s" % instr)
      registers.push(register)

      largest = (result > largest) ? result : largest
    end
  end
end

puts "Highest now: " + registers.map { |reg| eval(reg) }.max.to_s
puts "Highest ever: " + largest.to_s
