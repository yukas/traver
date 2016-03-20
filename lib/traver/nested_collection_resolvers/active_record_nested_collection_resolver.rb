module Traver
  class ActiveRecordNestedCollectionResolver
    def select_nested_collections_params(params, object_class)
      params.select { |name, value| nested_collection?(object_class, name, value) }
    end
    
    private
    
    def nested_collection?(object_class, field_name, field_value)
      if field_value.is_a?(Array)
        reflection = object_class.reflect_on_association(field_name)
        reflection && reflection.collection?
      end
    end
  end
end