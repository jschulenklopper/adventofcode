MAGIC_NUMBER = 23

class Marble  # TODO Make this a simple Struct.
    attr_accessor :next, :prev, :value

    def initialize(v)
        @value = v
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

    def delete  # Deletes marble at current position, return value.
        @count -= 1
        
        value = @current.value

        @current = @current.next
        @current.prev.prev.next = @current
        @current.prev = @current.prev.prev

        value
    end
end

def high_score(nr_players, last_marble)
    circle = Circle.new(0)  # Circle starts with marble 0 in.
    scores = Array.new(nr_players, 0)
    player = 0


    (1..last_marble).each do |marble|
        player += 1
        player = player % nr_players

        if marble % MAGIC_NUMBER == 0
            circle.backward(7)
            scores[player] += marble + circle.delete
        else
            circle.forward(2)
            circle.insert(marble)
        end
    end
    scores.max
end

while line = gets
    next if line[0] == "#"
    nr_players, last_marble = line.match(/^(\d+) players.*worth (\d+) points$/).captures.map(&:to_i)
    puts high_score(nr_players, last_marble)
end