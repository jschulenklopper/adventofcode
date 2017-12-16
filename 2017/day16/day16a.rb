class Array
  def swap!(a,b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

dance = gets.strip.split(",")
programs = "abcdefghijklmnop"

dance.each do |move|
  type, instr = move[0], move[1..-1]
  case type
    when "s"
      steps = instr.to_i
      programs = programs.chars.rotate(-1 * steps).join
    when "x"
      from, to = instr.split("/")[0].to_i, instr.split("/")[1].to_i
      programs = programs.chars.swap!(from,to).join
    when "p"
      f, t = instr.split("/")[0], instr.split("/")[1]
      from, to = programs.index(f), programs.index(t)
      programs = programs.chars.swap!(from,to).join
  end
end

puts programs
