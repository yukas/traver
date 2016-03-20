module Traver
  class ActiveRecordAttributeResolver
    def select_attributes_params(params, object_class)
      params.select { |name, value| regular_attribute?(object_class, name, value) }
    end
    
    private
    
    def regular_attribute?(object_class, name, value)
      if name.is_a?(Hash)
        reflection = object_class.reflect_on_association(field_name)
        !(reflection && !reflection.collection?)
      elsif name.is_a?(Array)
        reflection = object_class.reflect_on_association(field_name)
        !(reflection && reflection.collection?)
      else
        true
      end
    end
  end
end