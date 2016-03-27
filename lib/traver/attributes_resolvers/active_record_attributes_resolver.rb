module Traver
  class ActiveRecordAttributesResolver < AttributesResolver
    
    private
    
    def nested_object?(object_class, name, value)
      reflection = object_class.reflect_on_association(name)
      reflection && !reflection.collection?
    end
    
    def nested_collection?(object_class, name, value)
      if value.is_a?(Array)
        reflection = object_class.reflect_on_association(name)
        reflection && reflection.collection?
      end
    end
  end
end