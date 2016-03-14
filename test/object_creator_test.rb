require "test_helper"

class ObjectCreatorTest < TraverTest
  attr_reader :factory_definer, :object_persister, :nested_object_resolver, :nested_collection_resolver
  
  def setup
    super
    
    @factory_definer = FactoryDefiner.new
    @object_persister = PoroObjectPersister.new
    @nested_object_resolver = PoroNestedObjectResolver.new
    @nested_collection_resolver = PoroNestedCollectionResolver.new
  end
  
  def test_create_object
    define_class("Blog", :title)
    
    object_creator = ObjectCreator.new(:blog, { title: "Hello" }, factory_definer, object_persister, nested_object_resolver, nested_collection_resolver)
    object_creator.create_object
    
    assert_equal "Hello", object_creator.created_object.title
  end
  
  def test_after_create_hook
    define_class("Blog", :title)
    
    object = nil
    
    object_creator = ObjectCreator.new(:blog, { title: "Hello" }, factory_definer, object_persister, nested_object_resolver, nested_collection_resolver)
    object_creator.after_create = lambda do |creator|
      object = creator.created_object
    end
    
    object_creator.create_object
    
    assert_equal "Hello", object.title
  end
end