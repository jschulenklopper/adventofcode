MAGIC_NUMBER = 23

def high_score(nr_players, last_marble)
    circle = [0]  # Circle starts with marble 0 in.
    scores = Array.new(nr_players, 0)
    player = 0

    (1..last_marble).each do |marble|
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
puts high_score(nr_players, last_marble)