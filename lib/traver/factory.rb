module Traver
  class Factory
    attr_reader :name, :params, :parent_factory
    
    def initialize(name, params, parent_factory)
      @name   = name
      @params = params
      @parent_factory = parent_factory
    end
    
    def root_factory
      if parent_factory
        parent_factory.root_factory
      else
        self
      end
    end

    def root_name
      root_factory.name
    end
    
    def inherited_params
      if parent_factory
        parent_factory.inherited_params.merge(params)
      else
        params
      end
    end
    
    def object_class_name
      root_factory.name.to_s.camelize
    end
    
    def object_class
      Object.const_get(object_class_name)
    end
  end
end