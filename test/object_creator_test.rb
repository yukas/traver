require "test_helper"

class ObjectCreatorTest < MiniTest::Test
  include ClassDefinerHelper
  
  def test_create_object
    define_class(:blog, :title)
    object_creator = ObjectCreator.new(blog: { title: "Hello" })
    
    object_creator.create_object
    
    assert_equal "Hello", object_creator.created_object.title
  end
  
  def test_after_create_hook
    define_class(:blog, :title)
    object = nil
    
    object_creator = ObjectCreator.new(blog: { title: "Hello" })
    object_creator.after_create = lambda do |creator|
      object = creator.created_object
    end
    
    object_creator.create_object
    
    assert_equal "Hello", object.title
  end
end