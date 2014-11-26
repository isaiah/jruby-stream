$:.unshift(File.expand_path("../../lib", __FILE__))

require 'minitest/autorun'
require 'lazy_enumerator'

class LazyEnumeratorTest < MiniTest::Unit::TestCase
  def setup
    @s = [1,2,3].lazy
  end

  def test_map
    assert_kind_of Enumerator::Lazy, @s.map{|x| x + 1}
  end

  def test_force
    assert_equal [2,3,4], @s.map{|x| x + 1}.force
  end
end
