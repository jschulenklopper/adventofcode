fabric = Hash.new([])
all_ids = Array.new

while line = gets do
    # Parse a line.
    id, x, y, w, h = line.strip.match(/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/).captures.map(&:to_i)

    # Add id to list of all ids.
    all_ids << id

    w.times do |i|
        h.times do |j|
            # Enter claim on fabric; add id to list.
            fabric[[x+i,y+j]] += [id]

            # If there's more than one claim on the spot,
            # remove id and other ids on that spot from all_ids.
            if fabric[[x+i,y+j]].length > 1 
               all_ids.delete(id)
               fabric[[x+i,y+j]].each { |id| all_ids.delete(id) }
            end
        end
    end
end

puts all_ids.join(", ")