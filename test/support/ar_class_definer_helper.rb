require "support/ar_class_definer"

module ArClassDefinerHelper
  attr_reader :class_definer
  
  def define_class(*args, &block)
    class_definer.define_class(*args, &block)
  end
  
  def setup
    @class_definer = ArClassDefiner.new
  end
  
  def teardown
    class_definer.undefine_all_classes
  end
end