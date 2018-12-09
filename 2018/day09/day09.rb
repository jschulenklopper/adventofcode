MAGIC_NUMBER = 23

def high_score(nr_players, last_marble)
    circle = [0]  # Circle starts with marble 0 in.
    scores = Array.new(nr_players, 0)
    position = 0
    player = 0

    (1..last_marble).each do |marble|
        # puts "---" # Puts line for current round, before it starts.
        # puts "[%s] %s" % [player, circle.map { |c| "%2s" % c }.join(" ")]
        # puts "   %s --" % ["   " * position]

        # puts "-> marble: " + marble.to_s
        player += 1
        player = player % nr_players
        # puts "-> player: " + player.to_s

        if marble % MAGIC_NUMBER == 0
            scores[player] += marble
            position = (position - 7) % circle.length
            scores[player] += circle.delete_at(position)
        else
            position = (position + 1) % circle.length
            circle = circle.insert(position+1, marble)
            position = circle.find_index(marble)
        end
    end
    scores.max
end


while line = gets
    nr_players, last_marble = line.match(/^(\d+) players.*worth (\d+) points$/).captures.map(&:to_i)

    puts "==="
    puts "nr_players: %i" % nr_players
    puts "last_marble: %i" % last_marble

    puts high_score(nr_players, last_marble)
end