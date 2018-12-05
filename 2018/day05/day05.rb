line = gets.strip

result = []

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
end

p line.shrink.length