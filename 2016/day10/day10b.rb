class Factory < Hash
  def add(bot_name)
    if !self.include?(bot_name)
      then self[bot_name] = Bot.new(bot_name)
    end
    self[bot_name]
  end
end

class Bot
  attr_accessor :name, :chips
  attr_accessor :lo_dest, :hi_dest
  attr_reader :chips

  def initialize(name)  # name = {id}-{type}
    @chips = []
    @name = name
  end

  def to_s
    string = "%s, %s\n" % [@name, @chips.to_s]
  end

  def ==(another_bot)
    self.name == another_bot.name
  end

  def receives(value)
    if @name =~ /^bot/ && @chips.length < 2 && !chips.include?(value)
      @chips << value
    elsif @name =~ /^output/ && @chips.length < 1
      @chips = [value]
    end
  end

  def set_destinations(lo_dest, hi_dest)
    @lo_dest = lo_dest
    @hi_dest = hi_dest
  end

  def give!
    @lo_dest.receives(@chips.sort.first) 
    @hi_dest.receives(@chips.sort.last)
  end

  def can_give?
    return (@chips.length == 2 && @name =~ /^bot/ && @lo_dest && @hi_dest)
  end
end

factory = Factory.new

# Load all instructions.
while line = gets do
  line.match(/^bot (?<sourcebot>\d+) gives low to (?<lotype>\w+) (?<lodest>\d+) and high to (?<hitype>\w+) (?<hidest>\d+)/) do |match|
    source = factory.add("bot-" + match[:sourcebot])
    lodest = factory.add(match[:lotype] + "-" + match[:lodest])
    hidest = factory.add(match[:hitype] + "-" + match[:hidest])
    source.set_destinations(lodest, hidest)
  end

  line.match(/^value (?<value>\d+) goes to bot (?<bot>\d+)/) do |match|
    destbot = factory.add("bot-" + match[:bot])
    destbot.receives(match[:value].to_i)
  end
end

# Let the bots do their thing.
while true 
  factory.each_pair do |bot_name, bot|
    if bot.can_give? then bot.give! end
  end
  break if factory["output-0"].chips != [] && factory["output-1"].chips != [] && factory["output-2"].chips != []
end

# And display it after the action.
puts [factory["output-0"].chips[0], factory["output-1"].chips[0], factory["output-2"].chips[0]].reduce(:*)
