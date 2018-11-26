require 'minitest/autorun'

require './day24.rb'

class TestDay24 < Minitest::Test
  def test_max_strength
    bridges = [ [ [0,2], [2,2] ],
                [ [0,2], [2,2], [2,3] ] ] 
    max_strength = max_strength(bridges)
    assert_equal(11, max_strength)
  end

  def test_strength
    bridge = [ [0,1], [10,1], [9,10] ]
    strength = strength(bridge)
    assert_equal(31, strength)
  end

  def test_main
    output = main("example.txt")
    assert_equal([31,19], output)

  end
end