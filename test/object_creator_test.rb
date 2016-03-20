require "test_helper"

class ObjectCreatorTest < TraverTest
  def subject
    @subject ||= ObjectCreator.new(:blog, { title: "Hello" }, PoroSettings.new)
  end
  
  def setup
    super
    
    @factory_definer = FactoryDefiner.new
    @object_persister = PoroObjectPersister.new
    @nested_object_resolver = PoroNestedObjectResolver.new
    @nested_collection_resolver = PoroNestedCollectionResolver.new
  end
  
  def test_create_object
    define_class("Blog", :title)
    
    subject.create_object
    
    assert_equal "Hello", subject.object.title
  end
  
  def test_after_create_hook
    define_class("Blog", :title)
    
    object = nil
    
    subject.after_create = lambda do |creator|
      object = creator.object
    end
    
    subject.create_object
    
    assert_equal "Hello", object.title
  end
end