module Traver
  class TraverConstructor
    attr_reader :settings
    
    def initialize(settings)
      @settings = settings
    end
    
    def create(*options)
      factory_name, params = parse_create_options(options)
      
      object_creator = ObjectCreator.new(factory_name, params, settings, {})
      object_creator.create_object
    
      object_creator.object
    end
    
    def create_graph(*options)
      factory_name, params = parse_create_options(options)
    
      graph_creator = GraphCreator.new(factory_name, params, settings)
      graph_creator.create_graph
    
      graph_creator.graph
    end
    
    def create_list(num, *options)
      factory_name, params = parse_create_options(options)
      
      list_creator = ListCreator.new(num, factory_name, params, settings)
      list_creator.create_list
      
      list_creator.list
    end
    
    def define_factory(factory_name, *options)
      parent_factory_name, params = parse_factory_options(options)
    
      settings.define_factory(factory_name, parent_factory_name, params)
    end
    
    def undefine_all_factories
      settings.undefine_all_factories
    end
    
    private
    
    def parse_create_options(options)
      if factory_girl_options?(options)
        parse_factory_girl_options(options)
      else
        parse_traver_options(options)
      end
    end
    
    def factory_girl_options?(options)
      options.first.is_a?(Symbol)
    end
    
    def parse_factory_girl_options(options)
      factory_name, params = options
      params ||= {}
      
      [factory_name, params]
    end
    
    def parse_traver_options(options)
      options.first.first
    end
    
    def parse_factory_options(options)
      parent_factory_name = nil
    
      if options.size == 1
        params = options.first
      elsif options.size == 2
        parent_factory_name, params = options
      end
      
      [parent_factory_name, params]
    end
  end
end