string = "fbgdceah"

while line = gets
  puts string + " (%d)" % string.length
  puts (0..string.length-1).map { |i| i}.join

  puts line 

  # swap position X with position Y
  # IDENTICAL
  line.match(/swap position (?<X>\d+) with position (?<Y>\d+)/) { |match|
    x = match[:X].to_i
    y = match[:Y].to_i
    string[x], string[y] = string[y], string[x]
  }

  # swap letter X with letter Y
  # IDENTICAL
  line.match(/swap letter (?<X>\w) with letter (?<Y>\w)/) { |match|
    x = match[:X]
    y = match[:Y]
    ix = string.index(x)
    iy = string.index(y)
    string[ix], string[iy] = string[iy], string[ix]
  }

  # rotate left X steps
  # DONE
  line.match(/rotate left (?<X>\d+)/) { |match|
    x = match[:X].to_i
    string = string.chars.rotate(-1 * x).join
  }

  # rotate right X steps
  # DONE
  line.match(/rotate right (?<X>\d+)/) { |match|
    x = match[:X].to_i
    string = string.chars.rotate(x).join
  }

  # rotate based on position of letter X
  # TODO 
  # p string = "abcdefgh"

  # rotate based on position of letter X
  # p "ahead"
  # line.match(/rotate based on position of letter (?<X>\w)/) { |match|
    # x = match[:X]
    # i = string.index(x)
    # rotations = 1 + i + ((i >= 4) ? 1 : 0)
    # string = string.chars.rotate(-1 * rotations).join
  # }

  # p string
# 
  # p "roll-back"
  line.match(/rotate based on position of letter (?<X>\w)/) { |match|
    x = match[:X]
    p i = string.index(x)
    # new_pos = (i-1) / 2 + 1
    # new_pos = (i+1) / 2 
    # new_pos = (i/2) + 1
    # new_pos = (i + string.length) % string.length if i.even? && i != 0
    # new_pos = (i / 2) + 1
    i = (i + string.length) if i.even?
    p new_pos = (i / 2) - 1
    string = string.chars.rotate(new_pos).join
  }

  # reverse positions X through Y
  # IDENTICAL
  line.match(/reverse positions (?<X>\d+) through (?<Y>\d+)/) { |match|
    x = match[:X].to_i
    y = match[:Y].to_i
    prefix = (x > 0) ? string[0..(x-1)] : ""
    infix = string[(x..y)].reverse
    postfix = (y < string.length - 1) ? string[y+1..(string.length-1)] : ""
    string = prefix + infix + postfix
  }

  # move position X to position Y
  # DONE 
  line.match(/move position (?<X>\d+) to position (?<Y>\d+)/) { |match|
    x = match[:X].to_i
    y = match[:Y].to_i

    if x < y
      y -= 1
    end
    char = string[y]
    string.slice!(y)
    string = string.insert(x, char)
  }
  puts string
end

puts string
