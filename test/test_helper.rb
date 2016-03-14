$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "traver"

require "bundler/setup"
require "minitest/autorun"
require "support/class_definer"
require "support/model_definer"

class TraverTest < Minitest::Test
  include Traver
  
  def define_class(*args)
    class_definer.define_class(*args)
  end
  
  def define_model(*args, &block)
    model_definer.define_model(*args, &block)
  end
  
  def setup
    super
    
    Traver.factory_definer = FactoryDefiner.new
    Traver.object_persister = PoroObjectPersister.new
    Traver.factories_loader = NilFactoriesLoader.new
    Traver.nested_object_resolver = PoroNestedObjectResolver.new
  end
  
  def teardown
    super
    
    class_definer.undefine_all_classes
    model_definer.undefine_all_models
    
    Traver.factory_definer.undefine_all_factories
  end
  
  private
  
  def class_definer
    @class_definer ||= ClassDefiner.new
  end
  
  def model_definer
    @model_definer ||= ModelDefiner.new
  end
end