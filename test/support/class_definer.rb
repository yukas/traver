class ClassDefiner
  attr_reader :defined_class_names
  
  def initialize
    @defined_class_names = []
  end
  
  def define_class(class_name, *params)
    defined_class = if params.empty?
      Object.const_set(camelize(class_name.to_s), Class.new)
    else
      Object.const_set(camelize(class_name.to_s), Struct.new(*params))
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
    Object.send(:remove_const, camelize(class_name.to_s))
  end
  
  private
  
  def camelize(str)
    str.split('_').map(&:capitalize).join
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

    def test_defines_class_with_camel_case
      class_definer = ClassDefiner.new
    
      class_definer.define_class(:blog_post)
    
      assert defined?(BlogPost)
    
      Object.send(:remove_const, "BlogPost")
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
    
    def test_undefine_classes_with_camel_case
      class_definer = ClassDefiner.new
      class_definer.define_class(:blog_post)
      
      class_definer.undefine_all_classes
    
      refute defined?(BlogPost)
    end
  end
end