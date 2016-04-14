require "test_helper"

class ActiveRecordTest < TraverTest
  attr_reader :subject
  
  def setup
    super
    
    @subject = TraverConstructor.new
  end
  
  def teardown
    super
    
    subject.undefine_all_factories
  end
  
  def test_create_object
    define_model("Blog")

    blog = subject.create(:blog)

    assert_equal true, blog.persisted?
  end

  def test_create_object_with_attributes
    define_model("Blog", title: :string)

    blog = subject.create(blog: { title: "Hello" })

    assert_equal "Hello", blog.title
    assert_equal true, blog.persisted?
  end

  def test_create_object_using_factory
    define_model("Post", title: :string)
    subject.define_factory(:post, { title: "Hello" })

    post = subject.create(:post)

    assert_equal "Hello", post.title
    assert_equal true, post.persisted?
  end

  def test_create_object_using_child_factory
    define_model("Post", title: :string, published: :boolean)

    subject.define_factory(:post, { title: "Hello" })
    subject.define_factory(:published_post, :post, { published: true })

    post = subject.create(:published_post)

    assert_equal "Hello", post.title
    assert_equal true, post.published
    assert_equal true, post.persisted?
  end

  def test_create_associated_object
    define_model("User", name: :string)

    define_model("Blog", user_id: :integer, title: :string) do
      belongs_to :user
    end

    blog = subject.create(blog: {
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

    blog = subject.create(blog: {
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

  def test_create_collection_using_number
    define_model("Blog") do
      has_many :posts
    end

    define_model("Post", blog_id: :integer) do
      belongs_to :blog
    end
  
    blog = subject.create(blog: {
      posts: 2
    })
  
    assert_equal 2, blog.posts.length
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
     
    blog = subject.create(blog: {
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
    
    blog = subject.create(blog: {
      title: "Hello",
      user: { name: "Mike" }
    })
    
    assert_equal Hash[{ name: "Mike" }], blog.user
  end

  def test_assign_array_if_no_association_exists
    define_model("Blog", title: :string, posts: :string) do
      serialize :posts, Array
    end
    
    blog = subject.create(blog: {
      title: "Blog",
      posts: [
        { title: "Post" }
      ]
    })
    
    assert_equal [{ title: "Post" }], blog.posts
  end

  def test_automatically_creates_belongs_to_objects
    define_model("Blog", title: :string) do
      has_many :posts
    end

    define_model("Post", blog_id: :integer, title: :string) do
      belongs_to :blog
    end

    post = subject.create(:post)

    assert_equal true, post.persisted?
    assert_equal true, post.blog.persisted?
  end

  def test_reuse_parent_object_for_child_belongs_to_associations
    define_model("User", name: :string) do
      has_many :emails
    end

    define_model("Email", user_id: :integer, address: :string) do
      belongs_to :user
    end

    subject.define_factory :user, {
      emails: [{ }]
    }

    subject.define_factory :email, {
      address: "walter@white.com"
    }
    
    user = subject.create(:user)

    assert_equal user.emails.first.user, user
  end
  
  def test_has_one_association_reuses_parent_object_in_its_belongs_to_association
    define_model("Car") do
      has_one :driver
    end
    
    define_model("Driver", car_id: :integer) do
      belongs_to :car
    end
    
    graph = subject.create_graph(car: {
      driver: 1
    })
    
    assert_equal graph.car1.id, graph.driver1.car.id
  end
  
  def test_able_to_create_poro_object
    define_class("Blog", :title, :posts)
    define_class("Post", :title)
    
    result = subject.create_graph(blog: {
      title: "Hello",
      posts: [2, title: "Post ${n}"]
    })
    
    assert_equal "Hello", result.blog.title
    assert_equal 2, result.posts.length
    assert_equal "Post 1", result.post1.title
    assert_equal "Post 2", result.post2.title
  end
end