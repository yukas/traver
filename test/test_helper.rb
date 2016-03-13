$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "traver"

require "bundler/setup"
require "minitest/autorun"
require "support/class_definer"
require "support/model_definer"

class TraverTest < Minitest::Test
  def define_class(*args)
    class_definer.define_class(*args)
  end
  
  def define_model(*args)
    model_definer.define_model(*args)
  end
  
  def teardown
    class_definer.undefine_all_classes
    model_definer.undefine_all_models
  end
  
  private
  
  def class_definer
    @class_definer ||= ClassDefiner.new
  end
  
  def model_definer
    @model_definer ||= ModelDefiner.new
  end
end