require "test_helper"

class RubyAppTest < TraverTest
  attr_reader :subject
  
  def setup
    super
    
    @subject = Traver
  end
  
  def teardown
    super
    
    subject.undefine_all_factories
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
end