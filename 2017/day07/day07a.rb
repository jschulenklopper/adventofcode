programs = {}

while line = gets
  line.match(/^(?<id>\w+)\s+\((?<weight>\d+)\)(\s+->\s(?<above>.*))?/) do |match|
    # Find the list (if there is one) of programs about the current one.
    on_top = (match[:above]) ? match[:above].split(", ") : []
    # Store the program with its weight and connected nodes.
    programs[match[:id]] = [match[:weight], on_top]
  end
end

# Make a list of programs that are mentioned on top of others.
# Reject the programs for which the list of nodes is empty,
# then collect (and combine) all program ids mentioned.
above = programs.values.reject { |p| p[1] == [] }.map { |p| p[1] }.flatten

# Select the program that does not occur in on_top of other program
puts programs.select { |p| not above.include?(p) }.keys.first
