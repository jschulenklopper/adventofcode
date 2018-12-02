# Get all ids by reading file and splitting by newlines.
ids = gets(nil).split

# Process all 2-combinations of ids.
ids.combination(2).each do |id1, id2|
    common = []
    # Compare all characters, mark different characters as nil.
    id1.chars.each.with_index do |c, i|
        common[i] = (id1[i] == id2[i]) ? id1[i] : nil
    end
    # If there's just one difference (one nil value), output common.
    if common.count(nil) == 1
        puts common.compact.join
    end
end