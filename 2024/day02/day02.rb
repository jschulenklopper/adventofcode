reports = []
ARGF.readlines.each do |l|
  reports << l.strip.split.map(&:to_i)
end

def slope_ok?(report)
  return report.sort == report || report.sort.reverse == report
end

def differences_ok?(report)
  diffs = report[0..-2].map.with_index { |level,i| (level - report[i+1]).abs }
  diffs.reject { |level| level >= 1 && level <= 3}.empty?
end

# Part 1
valid = 0

reports.each do |report|
  valid += 1 if slope_ok?(report) && differences_ok?(report)
end

puts valid

# Part 2
valid = 0

reports.each do |report|
  # Create the series of alternative reports, in each one level removed.
  shorter = report.map.with_index { |level, i|
    # Creating an array with one element removed requires silliness.
    dupe = report.dup
    dupe.delete_at(i)
    short = dupe
  }

  shorter.each do |short|
    if slope_ok?(short) && differences_ok?(short)
      valid += 1
      break
    end
  end
end

puts valid
