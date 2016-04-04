require "traver/attributes_resolver"

module Traver
  class ActiveRecordAttributesResolver < AttributesResolver
    
    private
    
    def nested_object?(object_class, name, value)
      reflection = object_class.reflect_on_association(name)
      reflection && reflection.macro == :belongs_to
    end
    
    def has_one_object?(object_class, name, value)
      reflection = object_class.reflect_on_association(name)
      reflection && reflection.macro == :has_one
    end
    
    def nested_collection?(object_class, name, value)
      reflection = object_class.reflect_on_association(name)
      reflection && reflection.collection?
    end
  end
end