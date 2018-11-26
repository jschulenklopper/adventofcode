LOWEST = 0
HIGHEST = 4294967295

# Lower range.
lowest = LOWEST
highest = HIGHEST

ranges = [ [LOWEST, HIGHEST] ]

while line = gets
  line.strip!
  low, high = line.split("-").map(&:to_i)

  # Find ranges that range falls in.
  matching_ranges = ranges.select { |range|
    low <= range[1] && high >= range[0]
  }

  matching_ranges.each { |range|
    if high < range[1] && low > range[0]  # Split the range.
      ranges << [range[0], low-1]
      ranges << [high+1, range[1]]
      ranges.delete(range)
    end
    if high >= range[1] && low <= range[0]  # Delete the range.
      ranges.delete(range)
    end
    if low <= range[0] && high < range[1]  # Shorten the range.
      ranges << [high+1, range[1]]
      ranges.delete(range)
    end
    if low > range[0] && high >= range[1]  # Shorten the range.
      ranges << [range[0], low-1] 
      ranges.delete(range)
    end
  }

end


puts ranges.sort { |a, b| a[0] <=> b[0] }.first[0]  # Answer to part 1.

puts ranges.reduce(0) { |count, range| count += range[1] - range[0] + 1 }  # Part 2.