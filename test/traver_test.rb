require "test_helper"
require "support/class_definer_helper"

class TraverTest < Minitest::Test
  include ClassDefinerHelper
  
  def test_create_object
    define_class(:blog)
    
    blog = Traver.create(:blog)
    
    assert_instance_of Blog, blog
  end
  
  def test_create_object_with_attributes
    define_class(:blog, :title)
    
    blog = Traver.create(blog: { title: "Hello" })
    
    assert_equal "Hello", blog.title
  end
  
  def test_define_factory
    define_class(:post, :title)
    
    Traver.factory(:post, {
      title: "Hello"
    })
    
    post = Traver.create(:post)
    
    assert_equal "Hello", post.title
  end
end