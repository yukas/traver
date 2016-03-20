module Traver
  class ActiveRecordNestedObjectResolver
    def select_objects_params(params, object_class)
      params.select { |name, value| nested_object?(object_class, name, value) }
    end
    
    private
    
    def nested_object?(object_class, field_name, field_value)
      if field_value.is_a?(Hash)
        reflection = object_class.reflect_on_association(field_name)
        reflection && !reflection.collection?
      end
    end
  end
end