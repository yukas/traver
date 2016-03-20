module Traver
  class PoroNestedObjectResolver
    def select_objects_params(params, object_class)
      params.select { |name, value| nested_object?(object_class, name, value) }
    end
    
    private
    
    def nested_object?(object_class, name, value)
      if value.is_a?(Hash)
        Object.const_defined?(name.to_s.camelize)
      end
    end
  end
end