string = "abcdefgh"
# string = "abcde"  # Sample start.

while line = gets
  # puts string + " (%d)" % string.length
  # puts (0..string.length-1).map { |i| i}.join

  # swap position X with position Y
  line.match(/swap position (?<X>\d+) with position (?<Y>\d+)/) { |match|
    x = match[:X].to_i
    y = match[:Y].to_i
    string[x], string[y] = string[y], string[x]
  }

  # swap letter X with letter Y
  line.match(/swap letter (?<X>\w) with letter (?<Y>\w)/) { |match|
    x = match[:X]
    y = match[:Y]
    ix = string.index(x)
    iy = string.index(y)
    string[ix], string[iy] = string[iy], string[ix]
  }

  # rotate left X steps
  line.match(/rotate left (?<X>\d+)/) { |match|
    x = match[:X].to_i
    string = string.chars.rotate(x).join
  }

  # rotate right X steps
  line.match(/rotate right (?<X>\d+)/) { |match|
    x = match[:X].to_i
    string = string.chars.rotate(-1 * x).join
  }

  # rotate based on position of letter X
  line.match(/rotate based on position of letter (?<X>\w)/) { |match|
    x = match[:X]
    i = string.index(x)
    rotations = 1 + i + ((i >= 4) ? 1 : 0)
    string = string.chars.rotate(-1 * rotations).join
  }

  # reverse positions X through Y
  line.match(/reverse positions (?<X>\d+) through (?<Y>\d+)/) { |match|
    x = match[:X].to_i
    y = match[:Y].to_i
    prefix = (x > 0) ? string[0..(x-1)] : ""
    infix = string[(x..y)].reverse
    postfix = (y < string.length - 1) ? string[y+1..(string.length-1)] : ""
    string = prefix + infix + postfix
  }

  # move position X to position Y
  line.match(/move position (?<X>\d+) to position (?<Y>\d+)/) { |match|
    x = match[:X].to_i
    y = match[:Y].to_i
    char = string[x]
    string.slice!(x)
    string = string.insert(y, char)
  }
end

puts string