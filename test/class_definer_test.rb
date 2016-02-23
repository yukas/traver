require 'test_helper'
require 'support/class_definer'

class ClassDefinerTest < Minitest::Test
  def test_defines_class
    class_definer = ClassDefiner.new
    
    class_definer.define_class(:blog)
    
    assert defined?(Blog)
    
    Object.send(:remove_const, "Blog")
  end

  def test_undefines_class
    Object.const_set("Blog", Class.new)
    class_definer = ClassDefiner.new

    class_definer.undefine_class(:blog)
    
    refute defined?(Blog)
  end
  
  def test_undefine_defined_classes
    class_definer = ClassDefiner.new
    
    class_definer.define_class(:blog)
    class_definer.define_class(:post)
    class_definer.undefine_all_classes
    
    refute defined?(Blog)
    refute defined?(Post)
  end
end