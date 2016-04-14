require "test_helper"

class FactoryStoreTest < TraverTest
  attr_reader :subject
  
  def setup
    super
    
    @subject = FactoryStore.new
  end
  
  def test_define_factory
    subject.define_factory(:post, nil, title: "Hello")
    
    assert subject.factory_defined?(:post)
  end
  
  def test_factory_by_name
    subject.define_factory(:post, nil, published: true)
    
    factory = subject.factory_by_name(:post)
    
    assert_equal Hash[{ published: true }], factory.params
  end
  
  def test_undefine_all_factories
    subject.define_factory(:post, nil, title: "Hello")
    
    subject.undefine_all_factories
    
    assert_equal 0, subject.factories_count
  end
end