module Traver
  class PoroNestedCollectionResolver
    def select_nested_collections_params(params, object_class)
      params.select { |name, value| nested_collection?(object_class, name, value) }
    end
    
    def nested_collection?(object_class, name, value)
      if value.is_a?(Array)
        Object.const_defined?(name.to_s.singularize.camelize)
      end
    end
  end
end