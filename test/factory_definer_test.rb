require "test_helper"

class FactoryDefinerTest < TraverTest
  attr_reader :subject
  
  def setup
    super
    
    @subject = FactoryDefiner.new
  end
  
  def test_define_factory
    subject.define_factory(:post, nil, title: "Hello")
    
    assert_equal Hash[{ title: "Hello" }], subject.factory_params(:post)
    assert_equal nil, subject.parent_factory_name(:post)
  end
  
  def test_define_factory_with_a_parent
    subject.define_factory(:published_post, :post, published: true)
    
    assert_equal Hash[{
      published: true
    }], subject.factory_params(:published_post)
    
    assert_equal :post,
      subject.parent_factory_name(:published_post)
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