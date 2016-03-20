module Traver
  class PoroAttributeResolver
    def select_attributes_params(params, object_class)
      params.select { |name, value| regular_attribute?(object_class, name, value) }
    end
    
    private
    
    def regular_attribute?(object_class, name, value)
      if value.is_a?(Hash)
        !Object.const_defined?(name.to_s.camelize)
      elsif value.is_a?(Array)
        !Object.const_defined?(name.to_s.singularize.camelize)
      else
        true
      end
    end
  end
end