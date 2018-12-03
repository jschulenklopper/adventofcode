# Get the whole input file, split at newlines,
# convert to integers, and reduce array by adding all values.
puts gets(nil).split.map(&:to_i).reduce(0,&:+)