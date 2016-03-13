module Traver
  class FactoryDefiner
    def initialize
      undefine_all_factories
    end
    
    def define_factory(factory_name, parent_name, params)
      factories[factory_name] = Factory.new(factory_name, params, factory_by_name(parent_name))
    end
    
    def factory_params(factory_name)
      factory_by_name(factory_name).params
    end
    
    def parent_factory_name(factory_name)
      factory_by_name(factory_name).parent_factory &&
        factory_by_name(factory_name).parent_factory.name
    end

    def parent_factory_params(factory_name)
      factory_by_name(factory_name).parent_factory.params
    end
    
    def factory_by_name(factory_name)
      factories[factory_name] || default_factory(factory_name) if factory_name
    end
    
    def undefine_all_factories
      @factories = {}
    end
    
    def factories_count
      factories.keys.length
    end
    
    private
    attr_reader :factories
    
    def default_factory(factory_name)
      Factory.new(factory_name, {}, nil)
    end
  end
end