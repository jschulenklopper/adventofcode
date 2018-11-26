count = 0
ababab = /\[[a-z]*([a-z])((?!\1)[a-z])\1[a-z]*\]([a-z]+(\[[a-z]+\])+)*\2\1\2/
          # [
            # number of characters
                  # first character, captured as \1
                         # other charcter, captured as \2
                                      # same as \1
                                        # number of other characters
                                              # ]
                                                # number of other characters
                                                                         # same as \2
                                                                           # same as \1
                                                                             # same as \2

bababa = /([a-z])((?!\1)[a-z])\1.*\[[a-z]*\2\1\2[a-z]*\]/

while line = gets do
  puts line
  if line.strip.reverse =~ ababab || line.strip =~ ababab
    puts line
    count += 1
  end
  
end

puts count