module Traver
  class ActiveRecordAttributesResolver < AttributesResolver
    
    def select_objects_params(params, object_class)
      belongs_to_params = get_belongs_to_params(object_class)
      
      objects_params = params.select { |name, value| nested_object?(object_class, name, value) }
      
      belongs_to_params.merge(objects_params)
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
    
    def get_belongs_to_params(object_class)
      associations = object_class.reflect_on_all_associations(:belongs_to)
      
      associations.each_with_object({}) do |association, result|
        result[association.name] = {}
      end
    end
  end
end