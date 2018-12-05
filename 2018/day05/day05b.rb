line = gets.strip

class String
    # Shrink string by removing types of opposite polarity.
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

    # Remove type (and other polarity) from string.
    def remove_type(type)
        self.gsub(type.upcase, "").gsub(type.downcase, "")
    end
end

# Compute lengths of shrinked lines for all characters removed.
lengths = ("a".."z").map do |char|
    line.remove_type(char).shrink.length
end

puts lengths.min