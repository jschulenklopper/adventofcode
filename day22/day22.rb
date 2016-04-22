shop_inventory = [
  {name: "Magic Missile", cost: 53, damage: 4},
  {name: "Drain", cost: 73, damage: 2, hitpoints: 2},
  {name: "Shield", cost: 113, armor: 7, duration: 6},
  {name: "Poison", cost: 173, damage: 3, duration: 6},
  {name: "Recharge", cost: 229, mana: 101, duration: 5}
]

def buy_spells(inventory)
  # TODO
  number_of_items = 0
  while true
    number_of_items += 1
    # Pick a new combination of spells.
    inventory.combination(number_of_items).each do |serie|
      puts serie.to_s

      # Test whether it is allowed as series.
      # TODO

      yield serie
    end
  end
end

def cast_spell(actor, victim, cart)
end

def update_cart(cart)
  return cart.clone
end

def attack(actor, victim)
  # Compute damage.
  damage = [1, actor[:damage] - victim[:armor]].max

  # Apply damage, reduce hitpoints.
  victim[:hitpoints] -= damage
end

# Read input file for boss.
hitpoints = /(?<hitpoints>\d+)/.match(gets)[:hitpoints].to_i
damage = /(?<damage>\d+)/.match(gets)[:damage].to_i

winning_sequence = Hash.new
lowest_mana = nil

# Create valid combinations and see if it results in a win.
buy_spells(shop_inventory) do |spells|
  # Set up boss and me for start of new battle.
  boss = {name: "boss", hitpoints: hitpoints, damage: damage}
  me = {name: "me", hitpoints: 50, mana: 500}

  current_spells = spells.clone

  next

  while true 
    cast_spell(me, boss, current_spells)
    break if boss[:hitpoints] <= 0
    current_spells = update_spells(current_spells)

    attack(boss, me)
    break if me[:hitpoints] <= 0
  end

  # Determine if I won.
  if me[:hitpoints] > 0
    # Calculate costs of spells, and remember if it is lowest.
    mana = calculate_cost(spells)
    lowest_mana ||= manas
    lowest_mana = mana if mana < lowest_mana
  end
end

puts lowest_mana

# try_spell(available_spells, past_spells) => boolean
#   available_spells.each do |spell|
#     see if spell fits with past_spells
#     play round:
#       cast_spell
#       check if boss dead => return true
#       receive attack
#       check if I'm dead => return false
#     return try_spell(available_spells, past_spells + spell)

