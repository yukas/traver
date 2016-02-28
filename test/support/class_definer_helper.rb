require "support/class_definer"

module ClassDefinerHelper
  def define_class(*args)
    class_definer.define_class(*args)
  end
  
  def teardown
    class_definer.undefine_all_classes
  end
  
  private
  
  def class_definer
    @class_definer ||= ClassDefiner.new
  end
end