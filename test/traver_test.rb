require 'test_helper'

class TraverTest < Minitest::Test
  def test_creates_object
    define_class(:blog)
    
    blog = Traver.create(:blog)
    
    assert_instance_of Blog, blog
  end
end
