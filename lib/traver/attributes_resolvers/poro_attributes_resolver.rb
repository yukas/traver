require "traver/attributes_resolver"

module Traver
  class PoroAttributesResolver < AttributesResolver
    
    private
    
    def nested_object?(object_class, name, value)
      Object.const_defined?(name.to_s.camelize)
    end
    
    def has_one_object?(object_class, name, value)
      nested_object?(object_class, name, value)
    end
    
    def nested_collection?(object_class, name, value)
      if plural?(name)
        Object.const_defined?(name.to_s.singularize.camelize)
      end
    end
    
    def plural?(val)
      val.to_s.pluralize == val.to_s
    end
  end
end