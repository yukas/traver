require "test_helper"

class PoroTest < TraverTest  
  attr_reader :subject
  
  def setup
    @subject = TraverConstructor.new(PoroSettings.new)
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
end