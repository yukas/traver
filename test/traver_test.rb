class TraverTest < Minitest::Test
  include Traver
  
  attr_reader :class_definer, :model_definer
  
  def setup
    super
    
    @class_definer = ClassDefiner.new
    @model_definer = ModelDefiner.new
  end
  
  def define_class(*args)
    class_definer.define_class(*args)
  end
  
  def define_model(*args, &block)
    model_definer.define_model(*args, &block)
  end
  
  def teardown
    super
    
    class_definer.undefine_all_classes
    model_definer.undefine_all_models
  end
end