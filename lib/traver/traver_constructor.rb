module Traver
  class TraverConstructor
    attr_reader :settings
    
    def initialize(settings)
      @settings = settings
    end
    
    def define_factory(factory_name, *options)
      parent_factory_name = nil
    
      if options.size == 1
        params = options.first
      elsif options.size == 2
        parent_factory_name, params = options
      end
    
      settings.define_factory(factory_name, parent_factory_name, params)
    end
    
    def create(options)
      options = { options => {} } if options.is_a?(Symbol)
      
      factory_name, params = *options.first
      
      object_creator = ObjectCreator.new(factory_name, params, settings)
      object_creator.create_object
    
      object_creator.created_object
    end
    
    def create_graph(options)
      options = { options => {} } if options.is_a?(Symbol)
      
      factory_name, params = *options.first
    
      graph_creator = GraphCreator.new(factory_name, params, settings)
      graph_creator.create_graph
    
      graph_creator.graph
    end
    
    def undefine_all_factories
      settings.undefine_all_factories
    end
  end
end