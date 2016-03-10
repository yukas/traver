module Traver
  class FactoryDefiner
    attr_reader :defined_factories

    def self.instance
      @instance ||= FactoryDefiner.new
    end
    
    def initialize
      undefine_all_factories
    end
    
    def undefine_all_factories
      @defined_factories = {}
    end
    
    def define_factory(factory_name, *options)
      parent_name = nil
      
      if options.size == 1
        params = options.first
      elsif options.size == 2
        parent_name, params = options
      end
      
      defined_factories[factory_name] = { params: params, parent: parent_name }
    end
    
    def get_object_class(factory_name)
      if defined_factories[factory_name] && parent_name = defined_factories[factory_name][:parent]
        get_object_class(parent_name)
      else
        Object.const_get(camelize(factory_name.to_s))
      end
    end
    
    def apply_factory_params(factory_name, params)
      factory_params = get_factory_params(factory_name)
      
      factory_params.merge(params)
    end
    
    private
    
    def get_factory_params(factory_name)
      if factory = defined_factories[factory_name]
        get_factory_params(factory[:parent]).merge(factory[:params])
      end || {}
    end
    
    def camelize(str)
      str.split('_').map(&:capitalize).join
    end
  end
end