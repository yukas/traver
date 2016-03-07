require "test_helper"

class TraverTest < Minitest::Test
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
  
  def test_create_object_using_factory
    define_class(:post, :title)
    Traver.factory(:post, { title: "Hello" })
  
    post = Traver.create(:post)
  
    assert_equal "Hello", post.title
  end
  
  def test_create_object_using_child_factory
    define_class(:post, :title, :published)
    Traver.factory(:post, { title: "Hello" })
    Traver.factory(:published_post, :post, { published: true })
    
    post = Traver.create(:published_post)
    
    assert_equal "Hello", post.title
    assert_equal true, post.published
  end
  
  def test_create_associated_object
    define_class(:blog, :title, :user)
    define_class(:user, :name)

    blog = Traver.create(blog: {
      title: "Hello",
      user: { name: "Mike" }
    })

    assert_equal "Hello", blog.title
    assert_equal "Mike",  blog.user.name
 end
 
 def test_create_associated_collection
   define_class(:blog, :title, :posts)
   define_class(:post, :title)
   
   blog = Traver.create(blog: {
     title: "Hello",
     posts: [
       { title: "Post #1" },
       { title: "Post #2" }
     ]
   })
   
   assert_equal "Hello",   blog.title
   assert_equal "Post #1", blog.posts.first.title
   assert_equal "Post #2", blog.posts.last.title
 end
end