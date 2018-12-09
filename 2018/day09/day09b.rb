MAGIC_NUMBER = 23

class Marble
    attr_accessor :next, :prev, :value

    def initialize(v)
        @value = v
    end

    def to_s
        @value.to_s
    end
end

class Circle
    attr_accessor :current, :count

    def initialize(value)
        @count = 1

        marble = Marble.new(value)
        marble.next = marble
        marble.prev = marble

        @current = marble
    end

    def value
        @current.value
    end

    def insert(value)  # Inserts marble at current position.
        @count += 1

        marble = Marble.new(value)

        marble.prev = @current.prev
        marble.next = @current

        @current.prev.next = marble
        @current.prev = marble

        @current = marble
    end

    def forward(times = 1)
        times.times { @current = @current.next }
    end

    def backward(times = 1)
        times.times { @current = @current.prev }
    end

    def delete  # Deletes marble at current position.
        @count -= 1
        
        value = @current.value
        @current.prev = @current.next
        @current.next.prev = @current.prev

        @current = @current.next

        value
    end
end

def high_score(nr_players, last_marble)
    circle = [0]  # Circle starts with marble 0 in.
    scores = Array.new(nr_players, 0)
    player = 0

    (1..last_marble).each do |marble|
        # puts "---" # Puts line for current round, before it starts.
        # puts "[%2s] %s" % [player, circle.map { |c| "%2s" % c }.join(" ")]
        # puts "     --"

        player += 1
        player = player % nr_players

        if marble % MAGIC_NUMBER == 0
            circle.rotate!(-7)
            scores[player] += marble + circle.shift
        else
            circle.rotate!(2)
            circle.unshift(marble)
        end
    end
    scores.max
end

line = gets
nr_players, last_marble = line.match(/^(\d+) players.*worth (\d+) points$/).captures.map(&:to_i)
last_marble *= 1
puts high_score(nr_players, last_marble)
