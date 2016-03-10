require "test_helper"

class GraphCreatorTest < TraverTest
  include ClassDefinerHelper
  
  def test_create_graph
    define_class(:blog, :title)
    graph_creator = GraphCreator.new(blog: {title: "Hello"})
    
    graph_creator.create_graph
    
    assert_instance_of Blog, graph_creator.graph.blog
  end
end