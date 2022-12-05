rounds = ARGF.readlines.map(&:strip).map(&:split)

wins = { "X" => "C", "Y" => "A", "Z" => "B" }
draws = { "X" => "A", "Y" => "B", "Z" => "C" }
losses = { "X" => "B", "Y" => "C", "Z" => "A" }
shape_scores = { "X" => 1, "Y" => 2, "Z" => 3 }
outcome_scores = { win: 6, draw: 3, loss: 0 }
outcomes = { "X" => :loss, "Y" => :draw, "Z" => :win }

puts "part 1"
scores = rounds.map do |opponent, me|
  score = shape_scores[me]
  win = (wins[me] == opponent ? outcome_scores[:win] : 0 ) +
        (draws[me] == opponent ? outcome_scores[:draw] : 0)
  score + win
end
puts scores.sum

puts "part 2"
scores = rounds.map do |opponent, outcome|
  me = if (outcome == "Z") then wins.key(opponent)
      elsif (outcome == "X") then losses.key(opponent)
      else draws.key(opponent)
      end
  score = shape_scores[me]
  win = (wins[me] == opponent ? outcome_scores[:win] : 0 ) +
        (draws[me] == opponent ? outcome_scores[:draw] : 0)
  score + win
end
puts scores.sum
