WIDTH = 25
HEIGHT = 6

sif = ARGF.read.strip
nr_layers = sif.chars.length / (WIDTH * HEIGHT)

image = Hash.new

sif.chars.each_with_index { |c, i|
  layer = (i / (WIDTH*HEIGHT)).floor
  x = (i % (WIDTH*HEIGHT)) % WIDTH
  y = ((i % (WIDTH*HEIGHT)) / WIDTH).floor
  image[ [layer, x, y] ] = c
}

zero_pixel_count = (0...nr_layers).map do |layer|
  image.count { |k, v| image[k] == "0" && k[0] == layer }
end

# TODO This part can be made much nicer.
lowest = zero_pixel_count.min
lowest_layer = zero_pixel_count.find_index { |z| z == lowest }

puts image.count { |k, v| image[k] == "1" && k[0] == lowest_layer } *
     image.count { |k, v| image[k] == "2" && k[0] == lowest_layer }
