require './aoc.rb'
require "test/unit"

class TestTree < Test::Unit::TestCase
 
  def test_new
    tree = AoC::Tree.new
    assert_equal( 0, tree.size )

    test.add_node("A")
  end
 
end
