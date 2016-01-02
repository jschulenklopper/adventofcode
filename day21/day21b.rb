# Define possible weapons, armor, rings.
weapons = [
  {name: "dagger", cost: 8, damage: 4, armor: 0},
  {name: "shortsword", cost: 10, damage: 5, armor: 0},
  {name: "warhammer", cost: 25, damage: 6, armor: 0},
  {name: "longsword", cost: 40, damage: 7, armor: 0},
  {name: "greataxe", cost: 74, damage: 8, armor: 0}
]

armor = [
  {name: "leather", cost: 13, damage: 0, armor: 1},
  {name: "chainmail", cost: 31, damage: 0, armor: 2},
  {name: "splintmail", cost: 53, damage: 0, armor: 3},
  {name: "bandedmail", cost: 75, damage: 0, armor: 4},
  {name: "platemail", cost: 102, damage: 0, armor: 5}
]

rings = [
  {name: "damage +1", cost: 25, damage: 1, armor: 0},
  {name: "damage +2", cost: 50, damage: 2, armor: 0},
  {name: "damage +3", cost: 100, damage: 3, armor: 0},
  {name: "defense +1", cost: 20, damage: 0, armor: 1},
  {name: "defense +2", cost: 40, damage: 0, armor: 2},
  {name: "defense +3", cost: 80, damage: 0, armor: 3}
]

shop_inventory = {weapons: weapons, armor: armor, rings: rings}

def pick_from_list(min, max, list)
  return list if max == list.length
  result = []
  (min..max).each do |number|
    list.combination(number).each do |combination|
      result << combination
      yield combination
    end
  end
end

def purchase_stuff(inventory)
  # Purchase stuff, obeying the rules.
  # Rule: buy one weapon.
  pick_from_list(1,1,inventory[:weapons]) do |weapons|
    # Rule: buy at most one armor.
    pick_from_list(0,1,inventory[:armor]) do |armor|
      # Rule: buy at most two rings.
      pick_from_list(0,2,inventory[:rings]) do |rings|
        yield ({weapons: weapons, armor: armor, rings: rings})
      end
    end
  end
end

def put_stuff_on_player(stuff, player)
  # Consider each statistic.
  [:damage, :armor].each do |stat|
    # Loop over all the types of stuff.
    player[stat] += stuff.reduce(0) do |total, (key, type)|
      # Loop over all the items, and sum the stat.
      next if key == :total_cost
      total += type.reduce(0) do |sum, item|
        sum ||= 0
        sum += item[stat]
      end
    end
  end
end

def calculate_cost(cart)
  total_cost = cart.reduce(0) do |sum, (type, items)|
    sum += items.reduce(0) do |sum, item|
      sum += item[:cost]
    end
  end
  total_cost
end

def turn(actor, victim)
  # Compute damage.
  damage = [1, actor[:damage] - victim[:armor]].max

  # Apply damage, reduce hitpoints.
  victim[:hitpoints] -= damage
end

# Read input file for boss.
hitpoints = /(?<hitpoints>\d+)/.match(gets)[:hitpoints].to_i
damage = /(?<damage>\d+)/.match(gets)[:damage].to_i
armor = /(?<damage>\d+)/.match(gets)[:damage].to_i

losing_cart = Hash.new
highest_cost = 0

# Create valid combinations and see if it results in a win.
purchase_stuff(shop_inventory) do |cart|
  # Set up boss and me.
  boss = {name: "boss", hitpoints: hitpoints, damage: damage, armor: armor}
  me = {name: "me", hitpoints: 100, damage: 0, armor: 0}

  put_stuff_on_player(cart, me)

  while true 
    turn(me, boss)
    break if boss[:hitpoints] <= 0
    turn(boss, me)
    break if me[:hitpoints] <= 0
  end
  if me[:hitpoints] < 0
    cost = calculate_cost(cart)
    if cost > highest_cost
      losing_cart = cart
      highest_cost = cost
    end
  end
end

puts highest_cost

