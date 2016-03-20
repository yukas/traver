require "test_helper"

class PoroTest < TraverTest  
  def subject
    @subject ||= TraverConstructor.new(PoroSettings.new)
  end
  
  def test_create_object
    define_class("Blog")
    
    blog = subject.create(:blog)
    
    assert_instance_of Blog, blog
  end
  
  def test_create_object_with_attributes
    define_class("Blog", :title)
    
    blog = subject.create(blog: { title: "Hello" })
    
    assert_equal "Hello", blog.title
  end
  
  def test_create_object_with_a_factory
    define_class("Post", :title)
    subject.define_factory(:post, { title: "Hello" })
  
    post = subject.create(:post)
  
    assert_equal "Hello", post.title
  end
  
  def test_create_object_with_a_child_factory
    define_class("Post", :title, :published)
    subject.define_factory(:post, { title: "Hello" })
    subject.define_factory(:published_post, :post, { published: true })
    
    post = subject.create(:published_post)
    
    assert_equal "Hello", post.title
    assert_equal true, post.published
  end
  
  def test_create_associated_object
    define_class("Blog", :title, :user)
    define_class("User", :name)

    blog = subject.create(blog: {
      title: "Hello",
      user: { name: "Mike" }
    })

    assert_equal "Hello", blog.title
    assert_equal "Mike",  blog.user.name
 end
 
 def test_create_associated_collection
   define_class("Blog", :title, :posts)
   define_class("Post", :title)
   
   blog = subject.create(blog: {
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
   
   graph = subject.create_graph(blog: {
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
 
 def test_assign_hash_if_no_constant_defined
   define_class("Blog", :title, :user)
   
   blog = subject.create(blog: {
     title: "Hello",
     user: { name: "Mike" }
   })
   
   assert_equal Hash[{ name: "Mike" }], blog.user
 end
 
 def test_assign_array_if_no_constant_defined
   define_class("Blog", :title, :posts)
   
   blog = subject.create(blog: {
     title: "Blog",
     posts: [
       { title: "Post" }
     ]
   })
   
   assert_equal [{ title: "Post" }], blog.posts
 end
end