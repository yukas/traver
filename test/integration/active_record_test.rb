require "test_helper"

class ActiveRecordTest < TraverTest
  def setup
    super
    
    Traver.object_persister = ActiveRecordObjectPersister.new
    Traver.nested_object_resolver = ActiveRecordNestedObjectResolver.new
    Traver.nested_collection_resolver = ActiveRecordNestedCollectionResolver.new
  end
  
  def test_create_object
    define_model("Blog")

    blog = Traver.create(:blog)

    assert_equal true, blog.persisted?
  end

  def test_create_object_with_attributes
    define_model("Blog", title: :string)

    blog = Traver.create(blog: { title: "Hello" })

    assert_equal "Hello", blog.title
    assert_equal true, blog.persisted?
  end

  def test_create_object_using_factory
    define_model("Post", title: :string)
    Traver.define_factory(:post, { title: "Hello" })

    post = Traver.create(:post)

    assert_equal "Hello", post.title
    assert_equal true, post.persisted?
  end

  def test_create_object_using_child_factory
    define_model("Post", title: :string, published: :boolean)

    Traver.define_factory(:post, { title: "Hello" })
    Traver.define_factory(:published_post, :post, { published: true })

    post = Traver.create(:published_post)

    assert_equal "Hello", post.title
    assert_equal true, post.published
    assert_equal true, post.persisted?
  end

  def test_create_associated_object
    define_model("User", name: :string)

    define_model("Blog", user_id: :integer, title: :string) do
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
   define_model("Blog", title: :string) do
     has_many :posts
   end

   define_model("Post", blog_id: :integer, title: :string) do
     belongs_to :blog
   end

   blog = Traver.create(blog: {
     title: "Hello",
     posts: [
       { title: "Post #1" },
       { title: "Post #2" }
     ]
   })

   assert_equal "Hello", blog.title
   assert_equal true, blog.persisted?

   assert_equal "Post #1", blog.posts.first.title
   assert_equal true, blog.posts.first.persisted?

   assert_equal "Post #2", blog.posts.last.title
   assert_equal true, blog.posts.last.persisted?
 end

 def test_any_level_of_nesting
   define_model("Blog", title: :string) do
     has_many :posts
   end

   define_model("Post", blog_id: :integer, title: :string) do
     belongs_to :blog
     has_many :tags
   end

   define_model("Tag", post_id: :integer, name: :string) do
     belongs_to :post
   end

   blog = Traver.create(blog: {
     title: "Blog",
     posts: [{
       title: "Hello",
       tags: [{ name: "Tag" }]
     }]
   })

   assert_equal "Blog", blog.title
   assert_equal true, blog.persisted?

   assert_equal "Hello", blog.posts.first.title
   assert_equal true, blog.posts.first.persisted?

   assert_equal "Tag",   blog.posts.first.tags.first.name
   assert_equal true, blog.posts.first.tags.first.persisted?
 end
 
 def test_assign_hash_if_no_association_exists
   define_model("Blog", title: :string, user: :string) do
     serialize :user, Hash
   end
   
   blog = Traver.create(blog: {
     title: "Hello",
     user: { name: "Mike" }
   })
   
   assert_equal Hash[{ name: "Mike" }], blog.user
 end
 
 def test_assign_array_if_no_association_exists
   define_model("Blog", title: :string, posts: :string) do
     serialize :posts, Array
   end
   
   blog = Traver.create(blog: {
     title: "Blog",
     posts: [
       { title: "Post" }
     ]
   })
   
   assert_equal [{ title: "Post" }], blog.posts
 end
end