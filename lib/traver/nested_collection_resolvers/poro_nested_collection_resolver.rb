module Traver
  class PoroNestedCollectionResolver
    def nested_collection?(object_class, field_name, field_value)
      if field_value.is_a?(Array)
        Object.const_defined?(field_name.to_s.singularize.camelize)
      end
    end
  end
end