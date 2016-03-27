module Traver
  class ActiveRecordAttributesResolver < AttributesResolver
    
    def select_objects_params(params, object_class)
      params.select { |name, value| nested_object?(object_class, name, value) }
    end
    
    def select_collections_params(object, factory, params)
      collections_params = params.select { |name, value| nested_collection?(factory.object_class, name, value) }
      
      res = collections_params.each do |name, value|
        value.each do |hash|
          hash.merge!(factory.name => object)
        end
      end
      
      res
    end
    
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