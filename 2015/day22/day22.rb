# Read input file for boss.
hitpoints = 13 # DEBUG /(?<hitpoints>\d+)/.match(gets)[:hitpoints].to_i
damage = 8 # DEBUG /(?<damage>\d+)/.match(gets)[:damage].to_i

SHOP_INVENTORY = [
  {name: "Magic Missile", cost: 53, damage: 4, duration: 1},       # Added duration.
  {name: "Drain", cost: 73, damage: 2, hitpoints: 2, duration: 1}, # Added duration.
  {name: "Shield", cost: 113, armor: 7, duration: 6},
  {name: "Poison", cost: 173, damage: 3, duration: 6},
  {name: "Recharge", cost: 229, mana: 101, duration: 5}
]

SPELLS_LENGTH = 8 # DEBUG Just a first guess at number of turns necessary.

def select_spells(inventory)
  # Count, represented as string in base 5, is used to generate
  # all possible combinations of inventory, starting with one item
  # and adding items along the way.
  count = 0

  while count < inventory.length ** SPELLS_LENGTH
    # Convert count to base 5 number/string.
    code = count.to_s(inventory.length)

    code = "30" # DEBUG Remove this line - it is to test scripted battle from exercise.

    # Pick selection of spells according to code.
    spells = code.each_char.map { |char| inventory[char.to_i] }

    yield spells

    # Increase count for code of next combination.
    count += 1
  end
end

def select_spell(actor, victim, spells, turn)
  puts "\n>>>"
  puts "select_spell(%s, %s, %d, %d)" % [actor[:name], victim[:name], spells.length, turn]

  # Select current spell.
  spell = spells[turn]

  # Check if there's a spell to cast.
  if not spell
    puts "  no spell to cast"
    actor[:hitpoints] = 0
    return
  end

  # Check if actor has sufficient mana to cast spell.
  if actor[:mana] < spell[:cost]
    puts "  not enough mana to cast spell"
    actor[:hitpoints] = 0
    return
  end

  # Check if spell may be cast (no similar spell still running).
  if turn > 0 && spells[0 .. turn-1].select { |s| s[:name] == spell[:name] && s[:duration] > 0}.length > 0
    puts "  spell may not be cast yet"
    actor[:hitpoints] = 0
    return
  end

  # Deduct mana necessary for spell that is cast in this turn.
  actor[:mana] -= spell[:cost]
  actor[:mana_used] += spell[:cost]

  puts "  selected spell: %s" % spell.to_s

  return spell
end

def use_spell(actor, victim, spells, turn)
  puts "\n>>>"
  puts "use_spell(%s, %s, %d, %d)" % [actor[:name], victim[:name], spells.length, turn]

  puts "  list of spells:"
  puts spells

  # For the spell cast, compute effect and reduce duration.
  puts "  compute effect of all spells"

  spells[0..turn].each do |spell|

    puts "   considering spell %s" % spell.to_s

    # For all running spells...
    if spell[:duration] > 0

      puts "   applying spell %s" % [spell[:name]]

      case spell[:name]
        when "Magic Missile" # {name: "Magic Missile", cost: 53, damage: 4},
          puts "    damage %d" % spell[:damage]
          victim[:hitpoints] -= spell[:damage]

        when "Drain" # {name: "Drain", cost: 73, damage: 2, hitpoints: 2},
          puts "    damage %d" % spell[:damage]
          victim[:hitpoints] -= spell[:damage]
          puts "    hitpoints %d" % spell[:hitpoints]
          actor[:hitpoints] += spell[:hitpoints]

        when "Shield" # {name: "Shield", cost: 113, armor: 7, duration: 6},
          puts "    armor %d" % spell[:armor]
          actor[:armor] = spell[:armor] # sic

        when "Poison" # {name: "Poison", cost: 173, damage: 3, duration: 6},
          puts "    damage %d" % spell[:damage]
          victim[:hitpoints] -= spell[:damage]

        when "Recharge" # {name: "Recharge", cost: 229, mana: 101, duration: 5}
          puts "    mana %d" % spell[:mana]
          actor[:mana] += spell[:mana]
      end

      # Lower duration of spell.
      spell[:duration] -= 1
    end
  end
end

def attack(actor, victim, spells, turn)
  puts "\n<<<"
  puts "attack(%s, %s, %d, %d)" % [actor[:name], victim[:name], spells.length, turn]

  # Compute armor of victim (from running spells).
  armor = 0

  # Compute damage.
  armor = victim[:armor] ? victim[:armor] : 0
  damage = [1, actor[:damage] - armor].max

  # Apply damage, reduce hitpoints.
  victim[:hitpoints] -= damage
end

winning_sequence = Hash.new
lowest_mana = nil

# Create valid combinations and see if it results in a win.
select_spells(SHOP_INVENTORY) do |spells|
  puts "\n====="
  puts spells

  # Set up boss and me for start of new battle.
  # DEBUG boss = {name: "boss", hitpoints: hitpoints, damage: damage}
  boss = {name: "boss", hitpoints: 13, damage: 8}
  # DEBUG me = {name: "me", hitpoints: 50, mana: 500, mana_used: 0}
  me = {name: "me", hitpoints: 10, mana: 250, mana_used: 0}

  turn = 0

  puts "   me: HP %d, M %d (%d), boss: HP %d, D %d" % [me[:hitpoints], me[:mana], me[:mana_used], boss[:hitpoints], boss[:damage]]

  while true
    # My turn
    select_spell(me, boss, spells, turn)
    puts "-> me: HP %d, M %d (%d), boss: HP %d, D %d" % [me[:hitpoints], me[:mana], me[:mana_used], boss[:hitpoints], boss[:damage]]
    break if me[:hitpoints] <= 0

    # use_spell(me, boss, spells, turn)
    # puts "-> me: HP %d, M %d (%d), boss: HP %d, D %d" % [me[:hitpoints], me[:mana], me[:mana_used], boss[:hitpoints], boss[:damage]]
    # break if boss[:hitpoints] <= 0

    use_spell(me, boss, spells, turn)
    puts "-> me: HP %d, M %d (%d), boss: HP %d, D %d" % [me[:hitpoints], me[:mana], me[:mana_used], boss[:hitpoints], boss[:damage]]
    break if me[:hitpoints] <= 0

    # Boss' turn
    attack(boss, me, spells, turn)
    puts "-> me: HP %d, M %d (%d), boss: HP %d, D %d" % [me[:hitpoints], me[:mana], me[:mana_used], boss[:hitpoints], boss[:damage]]
    break if boss[:hitpoints] <= 0

    turn += 1
  end

  # Determine if I won.
  if me[:hitpoints] > 0 && boss[:hitpoints] <= 0
    puts "\n=> I won"
    # Get amount of mana used, and remember if it is lowest.
    mana_used = me[:mana_used]
    lowest_mana ||= mana_used
    lowest_mana = mana_used if mana_used < lowest_mana
  else
    puts "\n=> I lost"
  end

end

puts lowest_mana