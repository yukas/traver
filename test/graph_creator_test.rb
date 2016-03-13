require "test_helper"

class GraphCreatorTest < TraverTest
  def test_create_graph
    define_class("Blog", :title)
    factory_definer = FactoryDefiner.new
    graph_creator = GraphCreator.new(:blog,  {title: "Hello"}, factory_definer)
    
    graph_creator.create_graph
    
    assert_instance_of Blog, graph_creator.graph.blog
  end
end