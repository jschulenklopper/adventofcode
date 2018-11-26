# Create a hash to store registers, default value of new element is 0.
registers = Hash.new(0)
largest = 0

while line = gets
  # The line is almost a valid instruction in Ruby. We just need to 
  # change the variables into register references, and inc/dec to += and -=.
  instruction = line.gsub(/(\w+) (inc|dec)/, "registers['\\1'] \\2")
                    .gsub(/if (\w+)/, "if registers['\\1']")
                    .gsub(/ inc /, " += ")
                    .gsub(/ dec /, " -= ")

  # Evaluate the instruction and store largest, if a new value.
  result = eval(instruction) || largest
  largest = result if result > largest
end

puts "Highest at the end: %s" % registers.values.max
puts "Highest ever: %s" % largest