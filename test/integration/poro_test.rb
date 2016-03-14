require "test_helper"

class PoroTest < TraverTest  
  def test_create_object
    define_class("Blog")
    
    blog = Traver.create(:blog)
    
    assert_instance_of Blog, blog
  end
  
  def test_create_object_with_attributes
    define_class("Blog", :title)
    
    blog = Traver.create(blog: { title: "Hello" })
    
    assert_equal "Hello", blog.title
  end
  
  def test_create_object_with_a_factory
    define_class("Post", :title)
    Traver.define_factory(:post, { title: "Hello" })
  
    post = Traver.create(:post)
  
    assert_equal "Hello", post.title
  end
  
  def test_create_object_with_a_child_factory
    define_class("Post", :title, :published)
    Traver.define_factory(:post, { title: "Hello" })
    Traver.define_factory(:published_post, :post, { published: true })
    
    post = Traver.create(:published_post)
    
    assert_equal "Hello", post.title
    assert_equal true, post.published
  end
  
  def test_create_associated_object
    define_class("Blog", :title, :user)
    define_class("User", :name)

    blog = Traver.create(blog: {
      title: "Hello",
      user: { name: "Mike" }
    })

    assert_equal "Hello", blog.title
    assert_equal "Mike",  blog.user.name
 end
 
 def test_create_associated_collection
   define_class("Blog", :title, :posts)
   define_class("Post", :title)
   
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
 
 def test_create_graph
   define_class("Blog", :title, :posts)
   define_class("Post", :title, :tags)
   define_class("Tag",  :name)
   
   graph = Traver.create_graph(blog: {
     title: "Blog",
     posts: [{
       title: "Hello",
       tags: [{ name: "Tag" }]
     }]
   })
   
   assert_equal "Blog",  graph.blog.title
   
   assert_equal "Hello", graph.post.title
   assert_equal "Hello", graph.post1.title
   assert_equal "Hello", graph.posts.first.title
   
   assert_equal "Tag", graph.tag.name
   assert_equal "Tag", graph.tag1.name
   assert_equal "Tag", graph.tags.first.name
 end
 
 def test_assign_hash_to_field_if_there_are_no_constant_defined
   define_class("Blog", :title, :user)
   
   blog = Traver.create(blog: {
     title: "Hello",
     user: { name: "Mike" }
   })
   
   assert_equal Hash[{ name: "Mike" }], blog.user
 end
end