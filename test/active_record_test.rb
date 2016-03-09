require "test_helper"

class ActiveRecordTest < MiniTest::Test
  include ArClassDefinerHelper
  
  def setup
    super
    
    Object.const_set("Rails", Class.new)
  end
  
  def teardown
    super
    
    Object.send(:remove_const, "Rails")
  end
  
  def test_create_object
    define_class(:blog)
    
    blog = Traver.create(:blog)
    
    assert_equal true, blog.persisted?
  end
  
  def test_create_object_with_attributes
    define_class(:blog, title: :string)
    
    blog = Traver.create(blog: { title: "Hello" })
    
    assert_equal "Hello", blog.title
    assert_equal true, blog.persisted?
  end
  
  def test_create_object_using_factory
    define_class(:post, title: :string)
    Traver.factory(:post, { title: "Hello" })
  
    post = Traver.create(:post)
  
    assert_equal "Hello", post.title
    assert_equal true, post.persisted?
  end
  
  def test_create_object_using_child_factory
    define_class(:post, title: :string, published: :boolean)
    
    Traver.factory(:post, { title: "Hello" })
    Traver.factory(:published_post, :post, { published: true })
    
    post = Traver.create(:published_post)
    
    assert_equal "Hello", post.title
    assert_equal true, post.published
    assert_equal true, post.persisted?
  end
  
  def test_create_associated_object
    define_class(:user, name: :string)
    
    define_class(:blog, user_id: :integer, title: :string) do
      belongs_to :user
    end
    
    blog = Traver.create(blog: {
      title: "Hello",
      user: { name: "Mike" }
    })

    assert_equal "Hello", blog.title
    assert_equal "Mike",  blog.user.name
    assert_equal true, blog.persisted?
    assert_equal true, blog.user.persisted?
 end
 
 def test_create_associated_collection
   define_class(:blog, title: :string) do
     has_many :posts
   end
   
   define_class(:post, blog_id: :integer, title: :string) do
     belongs_to :blog
   end
   
   blog = Traver.create(blog: {
     title: "Hello",
     posts: [
       { title: "Post #1" },
       { title: "Post #2" }
     ]
   })
   
   assert_equal "Hello",   blog.title
   assert_equal true, blog.persisted?
   
   assert_equal "Post #1", blog.posts.first.title
   assert_equal true, blog.posts.first.persisted?
   
   assert_equal "Post #2", blog.posts.last.title
   assert_equal true, blog.posts.last.persisted?
 end
 
 def test_any_level_of_nesting
   define_class(:blog, title: :string) do
     has_many :posts
   end
   
   define_class(:post, blog_id: :integer, title: :string) do
     belongs_to :blog
     has_many :tags
   end
   
   define_class(:tag, post_id: :integer, name: :string) do
     belongs_to :post
   end
   
   blog = Traver.create(blog: {
     title: "Blog",
     posts: [{
       title: "Hello",
       tags: [{ name: "Tag" }]
     }]
   })
   
   assert_equal "Blog",  blog.title
   assert_equal true, blog.persisted?
   
   assert_equal "Hello", blog.posts.first.title
   assert_equal true, blog.posts.first.persisted?
   
   assert_equal "Tag",   blog.posts.first.tags.first.name
   assert_equal true, blog.posts.first.tags.first.persisted?
 end
end