require 'prime'

(109900..126900).step(17).collect { |n| !n.prime? }.count(true)
