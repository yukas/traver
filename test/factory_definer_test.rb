require "test_helper"

class FactoryDefinerTest < MiniTest::Test
  include ClassDefinerHelper
  
  attr_reader :subject
  
  def setup
    @subject = FactoryDefiner.new
  end
  
  def test_define_factory
    subject.define_factory(:post, title: "Hello")
    
    assert_equal Hash[
      post: {
        params: { title: "Hello" },
        parent: nil
      }
    ], subject.defined_factories
  end
  
  def test_undefine_all_factories
    subject.define_factory(:post, title: "Hello")
    
    subject.undefine_all_factories
    
    assert_equal Hash.new, subject.defined_factories
  end
  
  def test_define_factory_with_a_parent
    subject.define_factory(:published_post, :post, published: true)
    
    assert_equal Hash[
      published_post: {
        params: { published: true },
        parent: :post
      }
    ], subject.defined_factories
  end
  
  def test_apply_factory_params
    subject.define_factory(:post, title: "Hello")
    
    result = subject.apply_factory_params(:post, {})
    
    assert_equal Hash[title: "Hello"], result
  end
  
  def test_merge_parent_factory_params
    subject.define_factory(:post, title: "Hello")
    subject.define_factory(:tagged_post, :post, tags: "tag")
    subject.define_factory(:published_post, :tagged_post, published: true)
    
    result = subject.apply_factory_params(:published_post, {})
    
    assert_equal Hash[title: "Hello", tags: "tag", published: true], result
  end
  
  def test_get_object_class
    define_class(:post)
    
    subject.define_factory(:post, title: "Hello")
    subject.define_factory(:tagged_post, :post, tags: "tag")
    subject.define_factory(:published_post, :tagged_post, published: true)
    
    assert_equal Post, subject.get_object_class(:published_post)
  end
  
  def test_get_object_class_camel_case
    define_class(:blog_post)
    
    subject.define_factory(:blog_post, title: "Hello")
    
    assert_equal BlogPost, subject.get_object_class(:blog_post)
  end
end