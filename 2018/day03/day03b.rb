fabric = Hash.new([])
all_ids = Array.new

while line = gets do
    # Parse a line.
    id, x, y, w, h = line.strip.match(/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/).captures.map(&:to_i)

    # Add id to list of all ids.
    all_ids << id

    # Enter claim on fabric.
    w.times do |i|
        h.times do |j|
            fabric[[x+i,y+j]] += [id]
        end
    end
end

# Remove ids from all_ids if they end up in overlapping piece.
fabric.values.each { |ids|
    if ids.length > 1
        ids.each { |id| all_ids.delete(id) }
    end
}

puts all_ids.join(", ")