require "test_helper"

class TraverTest < Minitest::Test
  def test_create_object
    define_class(:blog)
    
    blog = Traver.create(:blog)
    
    assert_instance_of Blog, blog
  end
  
  def test_create_object_with_attributes
    define_class(:blog, :title)
    
    blog = Traver.create(blog: {title: "Hello"})
    
    assert_equal "Hello", blog.title
  end
  
  def test_define_factory
    define_class(:post, :title)
    Traver.factory(:post, { title: "Hello" })
  
    post = Traver.create(:post)
  
    assert_equal "Hello", post.title
  end
  
  def test_define_child_factory
    define_class(:post, :title, :published)
    Traver.factory(:post, { title: "Hello" })
    Traver.factory(:published_post, :post, { published: true })
    
    post = Traver.create(:published_post)
    
    assert_equal "Hello", post.title
    assert_equal true, post.published
  end
end