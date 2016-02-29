class ClassDefiner
  attr_reader :defined_class_names
  
  def initialize
    @defined_class_names = []
  end
  
  def define_class(class_name, *params)
    class_name = class_name.to_s.capitalize
  
    defined_class = if params.empty?
      Object.const_set(class_name, Class.new)
    else
      Object.const_set(class_name, Struct.new(*params))
    end
  
    defined_class_names << class_name
  
    defined_class
  end

  def undefine_all_classes
    defined_class_names.each do |class_name|
      undefine_class(class_name)
    end
  end

  def undefine_class(class_name)
    Object.send(:remove_const, class_name.to_s.capitalize)
  end
end

if __FILE__ == $0
  require "bundler/setup"
  require "minitest/autorun"
  require "support/class_definer"

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
end