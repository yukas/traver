require "test_helper"

class GraphCreatorTest < TraverTest
  attr_reader :factory_definer, :object_persister, :object_creator, :nested_object_resolver, :nested_collection_resolver
  
  def setup
    super
    
    @factory_definer = FactoryDefiner.new
    @object_persister = PoroObjectPersister.new
    @object_persister = PoroObjectPersister.new
    @nested_object_resolver = PoroNestedObjectResolver.new
    @nested_collection_resolver = PoroNestedCollectionResolver.new
    @object_creator = ObjectCreator.new(:blog,  { title: "Hello" }, factory_definer, object_persister, nested_object_resolver, nested_collection_resolver)
  end
  
  def test_create_graph
    define_class("Blog", :title)
    graph_creator = GraphCreator.new(object_creator)
    
    graph_creator.create_graph
    
    assert_instance_of Blog, graph_creator.graph.blog
  end
end