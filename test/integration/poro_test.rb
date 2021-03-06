require "test_helper"

class PoroTest < TraverTest  
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
 
  def test_create_associated_object_using_number
    define_class("Blog", :user)
    define_class("User")

    blog = subject.create(blog: {
      user: 1
    })
    
    assert_instance_of User, blog.user
  end
  
  def test_create_associated_object_using_factory_name
    define_class("User", :blog)
    define_class("Blog", :title)
    
    subject.define_factory(:funky_blog, :blog, {
      title: "Funky title"
    })
    
    user = subject.create(user: {
      blog: :funky_blog
    })
    
    assert_equal "Funky title", user.blog.title 
  end
  
  def test_create_associated_collection
    define_class("Blog", :posts)
    define_class("Post", :title)
  
    blog = subject.create(blog: {
      posts: [
        { title: "Post #1" },
        { title: "Post #2" }
      ]
    })
  
    assert_equal "Post #1", blog.posts.first.title
    assert_equal "Post #2", blog.posts.last.title
  end
  
  def test_create_collection_with_a_number
    define_class("Blog", :posts)
    define_class("Post", :title)
  
    blog = subject.create(blog: {
      posts: 2
    })
  
    assert_equal 2, blog.posts.length
    assert_instance_of Post, blog.posts.first
    assert_instance_of Post, blog.posts.last
  end

  def test_create_collection_with_number_and_params
    define_class("Blog", :posts)
    define_class("Post", :title)
  
    blog = subject.create(blog: {
      posts: [ 2, title: "Post" ]
    })
  
    assert_equal "Post",  blog.posts.first.title
    assert_equal "Post",  blog.posts.last.title
  end

  def test_create_collection_using_number_and_factory_name
    define_class("Blog", :posts)
    define_class("Post", :published)
    
    subject.define_factory(:published_post, :post, { published: true })
  
    blog = subject.create(blog: {
      posts: [ 2, :published_post ]
    })
  
    assert_equal true,  blog.posts.first.published
    assert_equal true,  blog.posts.last.published
  end

  def test_create_collection_using_factory_names
    define_class("Blog", :posts)
    define_class("Post", :published)
    
    subject.define_factory(:published_post, :post, { published: true })
    subject.define_factory(:draft_post,     :post, { published: false })
  
    blog = subject.create(blog: {
      posts: [ :published_post, :draft_post ]
    })
    
    assert_equal true,  blog.posts.first.published
    assert_equal false, blog.posts.last.published
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

  def test_assign_hash_instead_of_creating_association_object_if_no_constant_defined
    define_class("Blog", :title, :user)
  
    blog = subject.create(blog: {
      title: "Hello",
      user: { name: "Mike" }
    })
  
    assert_equal Hash[{ name: "Mike" }], blog.user
  end

  def test_assign_array_instead_of_creating_collection_objects_if_no_constant_defined
    define_class("Blog", :title, :posts)
  
    blog = subject.create(blog: {
      title: "Blog",
      posts: [
        { title: "Post" }
      ]
    })
  
    assert_equal [{ title: "Post" }], blog.posts
  end

  def test_create_list
    define_class("User", :name)
  
    users = Traver.create_list(2, user: { name: "Walter" })
  
    assert_equal 2, users.length
    assert_equal "Walter", users.first.name
    assert_equal "Walter", users.last.name
  end
  
  def test_sequence
    define_class("Blog", :posts)
    define_class("Post", :title)

    subject.define_factory(:post, {
      title: "Post ${n}"
    })

    blog = subject.create(blog: {
      posts: 2
    })

    assert_equal "Post 1", blog.posts.first.title
    assert_equal "Post 2", blog.posts.last.title
  end
  
  def test_sequences_for_different_attributes_are_different
    define_class("Blog", :posts, :tags)
    define_class("Post", :title)
    define_class("Tag", :name)

    subject.define_factory(:post, {
      title: "Post ${n}"
    })

    subject.define_factory(:tag, {
      name: "Tag ${n}"
    })

    blog = subject.create(blog: {
      posts: 2,
      tags: 2
    })

    assert_equal "Post 1", blog.posts.first.title
    assert_equal "Post 2", blog.posts.last.title
    
    assert_equal "Tag 1", blog.tags.first.name
    assert_equal "Tag 2", blog.tags.last.name
  end
  
  def test_accept_proc_as_a_value_for_attribute
    define_class("Post", :published_at)
    time = DateTime.now
    
    DateTime.stub(:now, time) do
      post = subject.create(post: {
        published_at: -> { DateTime.now }
      })
    
      assert_equal time, post.published_at
    end
  end
  
  def test_evaluate_proc_with_one_argument_which_is_created_object
    define_class("User", :first_name, :last_name, :full_name)
    
    user = subject.create(user: {
      first_name: "Walter",
      last_name: "White",
      full_name: -> o { "#{o.first_name} #{o.last_name}" }
    })
    
    assert_equal "Walter White", user.full_name
  end
  
  def test_evaluate_proc_with_zero_arguments
    define_class("User", :first_name, :last_name, :full_name)
    
    full_name = "Walter White"
    
    user = subject.create(user: {
      first_name: "Walter",
      last_name: "White",
      full_name: -> { full_name }
    })
    
    assert_equal "Walter White", user.full_name
  end
  
  def test_define_factories
    subject.define_factories do
      define_factory :user, {
        name: "Walter"
      }
    end
    
    assert_equal 1, subject.factories_count
  end
  
  def test_factories
    subject.factories do
      factory :user, {
        name: "Walter"
      }
      
      factory :blog, {
        title: "Hello"
      }
    end
    
    assert_equal 2, subject.factories_count
  end
  
  def test_support_factory_girl_syntax_for_create
    define_class("Blog", :title)
    
    blog = subject.create(:blog, title: "Hello")
    
    assert_equal "Hello", blog.title
  end

  def test_support_factory_girl_syntax_for_create_graph
    define_class("Blog", :title)
    
    graph = subject.create_graph(:blog, title: "Hello")
    
    assert_equal "Hello", graph.blog.title
  end
  
  def test_support_factory_girl_syntax_for_create_list
    define_class("Blog", :title)
    
    blogs = subject.create_list(2, :blog, title: "Hello")
    
    assert_equal 2, blogs.length
    assert_equal "Hello", blogs.first.title
    assert_equal "Hello", blogs.last.title
  end
  
  # def test_able_to_create_poro_and_ar_objects
  #   define_model("User", name: :string) do
  #     attr_accessor :blog
  #   end
  #
  #   define_class("Blog", :title)
  #
  #   result = subject.create_graph(user: {
  #     name: "Walter",
  #     blog: {
  #       title: "Hello"
  #     }
  #   })
  #
  #   assert_equal "Walter", result.user.name
  #   assert_equal true,     result.user.persisted?
  #   assert_equal "Hello",  result.blog.title
  # end
end