line = gets.strip

class String
    def shrink
        result = []

        self.chars.each do |c|
            if (result.last != nil) && (result.last.ord - c.ord).abs == 32
                result.pop
            else
                result.push(c)
            end
        end

        result.join
    end

    def remove_type(type)
        self.gsub(type.upcase, "").gsub(type.downcase, "")
    end
end

min_length = Float::INFINITY

# TODO Use min()
("a".."z").each do |char|
    result = line.remove_type(char).shrink
    if result.length < min_length
        min_length = result.length
    end
end

puts min_length