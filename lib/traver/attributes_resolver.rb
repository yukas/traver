module Traver
  class AttributesResolver
    def select_attributes_params(params, object_class)
      params.select { |name, value| regular_attribute?(object_class, name, value) }
    end
    
    def select_objects_params(params, object_class)
      params.select { |name, value| nested_object?(object_class, name, value) }
    end
    
    def select_collections_params(object, factory, params)
      params.select { |name, value| nested_collection?(factory.object_class, name, value) }
    end
    
    private
    
    def regular_attribute?(object_class, name, value)
      !nested_object?(object_class, name, value) && !nested_collection?(object_class, name, value)
    end
  end
end