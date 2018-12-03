fabric = Hash.new([])
all_ids = Array.new

while line = gets do
    # Parse a line.
    id, x, y, w, h = line.strip.match(/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/).captures.map(&:to_i)

    all_ids << id

    w.times do |i|
        h.times do |j|
            px, py = x + i, y + j
            if fabric[[px,py]][1] == nil
                fabric[[px,py]] = [[],0]
            end
            fabric[[px,py]][0] << id
            fabric[[px,py]][1] += 1
        end
    end
end

# Remove ids from all_ids if they end up in overlapping piece.
fabric.values.each { |ids,count|
    if count > 1
        ids.each { |id|
          all_ids.delete(id)
        }
    end
}

puts all_ids