module Traver
  class ActiveRecordNestedCollectionResolver
    def nested_collection?(object_class, field_name, field_value)
      if field_value.is_a?(Array)
        reflection = object_class.reflect_on_association(field_name)
        
        reflection && reflection.collection?
      end
    end
  end
end