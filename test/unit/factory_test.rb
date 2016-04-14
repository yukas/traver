require "test_helper"

class FactoryTest < TraverTest
  def test_root_factory
    post_factory       = Factory.new(:post, {}, nil)
    draft_post_factory = Factory.new(:draft_post, { published: false }, post_factory)
    
    assert_equal post_factory, draft_post_factory.root_factory
  end
  
  def test_root_name
    post_factory       = Factory.new(:post, {}, nil)
    draft_post_factory = Factory.new(:draft_post, { published: false }, post_factory)
    
    assert_equal :post, draft_post_factory.root_name
  end
  
  def test_inherited_params
    post_factory       = Factory.new(:post, { title: "Hello" }, nil)
    draft_post_factory = Factory.new(:draft_post, { published: false }, post_factory)
    
    assert_equal({ title: "Hello", published: false }, draft_post_factory.inherited_params)
  end
end