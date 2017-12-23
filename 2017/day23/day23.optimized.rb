require 'prime'

puts (109900..126900).step(17).count { |n| !n.prime? }
