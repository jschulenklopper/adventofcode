WIDTH = 25
HEIGHT = 6

sif = ARGF.read.strip

nr_layers = sif.chars.length / (WIDTH * HEIGHT)

image = Hash.new

sif.chars.each_with_index { |c, i|
  layer = (i / (WIDTH*HEIGHT)).floor
  x = (i % (WIDTH * HEIGHT) % WIDTH)
  y = (i % (WIDTH * HEIGHT) / WIDTH).floor
  image[ [layer, x, y] ] = c
}

line = ""

(0...HEIGHT).each do |y|
  (0...WIDTH).each do |x|
    pixel = (0...nr_layers).reduce("2") { |memo, l|
      if image[ [l,x,y] ] == "0" && memo == "2" then " "
      elsif image[ [l,x,y] ] == "1" && memo == "2" then "X"
      else memo
      end
    }
    line += pixel
  end
  line += "\n"
end

puts line