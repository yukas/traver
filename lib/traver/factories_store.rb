module Traver
  class FactoriesStore
    def initialize
      undefine_all_factories
    end
    
    def define_factory(factory_name, parent_name, params)
      factories[factory_name] = Factory.new(factory_name, params, factory_by_name(parent_name))
    end
    
    def factory_defined?(factory_name)
      factories.has_key?(factory_name)
    end
    
    def factory_by_name(factory_name)
      if factory_name
        factories[factory_name] || empty_factory(factory_name)
      end
    end
    
    def undefine_all_factories
      @factories = {}
    end
    
    def factories_count
      factories.keys.length
    end
    
    alias :factory :define_factory
    
    private
    attr_reader :factories
    
    def empty_factory(factory_name)
      Factory.new(factory_name, {}, nil)
    end
  end
end