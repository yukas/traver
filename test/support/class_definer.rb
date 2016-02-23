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
