module Traver
  class PoroAttributesResolver < AttributesResolver
    
    private
    
    def nested_object?(object_class, name, value)
      if value.is_a?(Hash)
        Object.const_defined?(name.to_s.camelize)
      end
    end

    def nested_collection?(object_class, name, value)
      if value.is_a?(Array)
        Object.const_defined?(name.to_s.singularize.camelize)
      end
    end
  end
end