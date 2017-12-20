require 'minitest/autorun'
require 'minitest/pride'

require './day20.rb'

class TestDay20 < Minitest::Test
  def setup
  end

  def test_main
    assert_equal([367,707], main('input.txt'))
  end
end
