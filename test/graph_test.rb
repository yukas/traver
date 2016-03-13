require "test_helper"

class GraphTest < TraverTest
  attr_reader :subject
  
  def setup
    super
    
    @subject = Graph.new
  end
  
  def test_add_vertex
    subject.add_vertex(:blog, "Blog")
    subject.add_vertex(:post, "Post")
    
    assert_equal "Blog", subject.blog
    assert_equal "Post", subject.post
  end
  
  def test_add_vertex_with_identical_key
    subject.add_vertex(:blog, "Object #1")
    subject.add_vertex(:blog, "Object #2")
    
    assert_equal "Object #1", subject.blog
    assert_equal "Object #1", subject.blog1
    assert_equal "Object #2", subject.blog2
  end
  
  def test_vertices_collection
    subject.add_vertex(:blog, "Object #1")
    subject.add_vertex(:blog, "Object #2")
    
    assert_equal ["Object #1", "Object #2"], subject.blogs
  end
  
  def test_access_vertices_via_method_calls
    subject.add_vertex(:blog, "Object #1")
    
    assert_equal "Object #1", subject.blog
  end
end