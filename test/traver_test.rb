require "test_helper"
require "support/class_definer_helper"

class TraverTest < Minitest::Test
  include ClassDefinerHelper
  
  def test_creates_object
    define_class(:blog)
    
    blog = Traver.create(:blog)
    
    assert_instance_of Blog, blog
  end
  
  def test_creates_object_with_attributes
    define_class(:blog, :title)
    
    blog = Traver.create(blog: { title: "Hello" })
    
    assert_equal "Hello", blog.title
  end
end