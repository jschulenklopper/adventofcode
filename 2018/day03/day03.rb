fabric = Hash.new(0)

while line = gets do
    # Parse a line and get values from it.
    id, x, y, w, h = line.strip.match(/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/).captures.map(&:to_i)

    # Update fabric by increasing counter for area of this piece.
    w.times do |i|
        h.times do |j|
            fabric[[x+i,y+j]] += 1
        end
    end
end

# Return areas in fabric with count above 1.
puts fabric.values.count { |i| i > 1 }