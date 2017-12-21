require 'minitest/autorun'
require 'minitest/pride'

require './day21.rb'

class TestDay21 < Minitest::Test
  def setup
    @m = Matrix[ [1,2,3], [4,5,6], [7,8,9] ]
    @g = Matrix.from_grid([".#.", "..#", "###"])
  end

  def test_from_grid
    assert_equal(Matrix.from_grid(["123", "456", "789"]), @m.collect(&:to_s))
  end

  def test_pixel_count
    assert_equal(5, @g.pixel_count)
    assert_equal(0, Matrix.from_grid(["..", "..", ".."]).pixel_count)
    assert_equal(4, Matrix.from_grid(["##", "##"]).pixel_count)
  end

  def test_flip_rows
    m_flipped = Matrix[[7,8,9], [4,5,6], [1,2,3]]
    assert_equal(m_flipped, @m.flip_rows)
  end

  def test_flip_columns
    m_flipped = Matrix[[3,2,1], [6,5,4], [9,8,7]]
    assert_equal(m_flipped, @m.flip_columns)
  end

  def test_rotate
    m_rotated = Matrix[[7,4,1],[8,5,2],[9,6,3]]
    m_rotated_twice = Matrix[[9,8,7], [6,5,4], [3,2,1]]
    assert_equal(m_rotated, @m.rotate)
    assert_equal(m_rotated_twice, @m.rotate.rotate)
    assert_equal(@m, @m.rotate.rotate.rotate.rotate)
  end

  def test_options
    # TODO
  end

  def test_join
    goal = Matrix[["1", "2", "5", "6"], ["3", "4", "7", "8"], ["9", "0", "c", "d"], ["a", "b", "e", "f"]]
    minor_1 = Matrix.from_grid(["12", "34"])
    minor_2 = Matrix.from_grid(["56", "78"])
    minor_3 = Matrix.from_grid(["90", "ab"])
    minor_4 = Matrix.from_grid(["cd", "ef"])
    assert_equal(goal, Matrix.join([minor_1, minor_2, minor_3, minor_4]))
  end
end
