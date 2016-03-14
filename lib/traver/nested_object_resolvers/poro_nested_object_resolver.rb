module Traver
  class PoroNestedObjectResolver
    def nested_object?(object_class, field_name, field_value)
      if field_value.is_a?(Hash)
        Object.const_defined?(field_name.to_s.camelize)
      end
    end
  end
end