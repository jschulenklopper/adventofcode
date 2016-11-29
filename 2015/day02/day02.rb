total_paper = 0
total_ribbon = 0

while line = gets
  captures = line.match(/(\d+)x(\d+)x(\d+)/).captures
  l,w,h = captures[0].to_i, captures[1].to_i, captures[2].to_i

  side1, side2, side3 = l*w, w*h, h*l
  area = 2*side1 + 2*side2 + 2*side3 + [side1, side2, side3].min

  ribbon = [l, w, h].min(2).inject(:+)*2
  bow = l*w*h
  puts " %d" % [bow]

  total_paper += area
  total_ribbon += bow + ribbon
end

puts "paper: %d" % total_paper
puts "ribbon: %d" % total_ribbon
