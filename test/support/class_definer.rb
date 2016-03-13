class ClassDefiner
  attr_reader :defined_classes
  
  def initialize
    @defined_classes = []
  end
  
  def define_class(class_name, *params)
    defined_class = if params.empty?
      Object.const_set(class_name, Class.new)
    else
      Object.const_set(class_name, Struct.new(*params))
    end
  
    defined_classes << defined_class
  
    defined_class
  end

  def undefine_all_classes
    defined_classes.each do |klass|
      undefine_class(klass)
    end
    
    @defined_classes = []
  end
  
  private

  def undefine_class(klass)
    Object.send(:remove_const, klass.name)
  end
end

if __FILE__ == $0
  require "bundler/setup"
  require "minitest/autorun"
  require "support/class_definer"

  class ClassDefinerTest < Minitest::Test
    attr_reader :subject
    
    def setup
      super
      
      @subject = ClassDefiner.new
    end
    
    def teardown
      super
      
      subject.undefine_all_classes
    end
    
    def test_define_class
      subject.define_class("Blog")
    
      assert defined?(Blog)
    end
    
    def test_define_class_with_attributes
      subject.define_class("Blog", :title)
      
      assert_includes Blog.instance_methods, :title
    end
    
    def test_undefine_all_classes
      subject.define_class("Blog")
      subject.define_class("Post")
      
      subject.undefine_all_classes
    
      refute defined?(Blog)
      refute defined?(Post)
    end
  end
end