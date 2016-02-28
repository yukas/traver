module Traver
  class FactoryDefiner
    attr_reader :defined_factories
    
    def initialize
      @defined_factories = {}
    end
    
    def self.instance
      @instance ||= FactoryDefiner.new
    end
    
    def define_factory(class_name, params)
      defined_factories[class_name] = params
    end
    
    def apply_factory_params(class_name, params)
      factory_params = get_factory_params(class_name)
      
      factory_params.merge(params)
    end
    
    private
    
    def get_factory_params(class_name)
      defined_factories[class_name] || {}
    end
  end
end