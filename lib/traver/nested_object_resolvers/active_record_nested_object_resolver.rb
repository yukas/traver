module Traver
  class ActiveRecordNestedObjectResolver
    def nested_object?(object_class, field_name, field_value)
      if field_value.is_a?(Hash)
        reflection = object_class.reflect_on_association(field_name)
        
        reflection && !reflection.collection?
      end
    end
  end
end