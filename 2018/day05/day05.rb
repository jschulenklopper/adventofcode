line = gets.strip

result = []

def shrink(line)
    result = []

    line.chars.each do |c|
        if (result.last != nil) && (result.last.ord - c.ord).abs == 32
            result.pop
        else
            result.push(c)
        end
    end
    result.join
end

p shrink(line).length