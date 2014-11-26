require 'minitest/autorun'
require './lazy'

class TestLazyEnumerator < MiniTest::Unit::TestCase
  def setup
    r = 1..Float::INFINITY
    @s = r.lazy
  end

  def test_map
    assert_equal([101,102,103], @s.map{|x| x + 100}.take(3).force)
  end

  def test_select
    assert_equal([1,3,5], @s.select(&:odd?).take(3).force)
  end

  def test_drop
    assert_equal([7], @s.drop(6).take(1).force)
  end

  def test_drop_while
    assert_equal([11,12,13], @s.drop_while{|x| x <= 10}.take(3).force)
  end

  def test_take_while
    assert_equal((1..10).to_a, @s.take_while{|x| x <= 10}.force)
  end
end
