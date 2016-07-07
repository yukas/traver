module Traver
  class TraverConstructor
    attr_reader :factories_store, :sequencer
    
    def initialize
      @factories_store = FactoriesStore.new
      @sequencer       = Sequencer.new
    end
    
    def include(*modules)
      modules.each do |mod|
        self.class.send(:include, mod)
      end
    end
    
    def create(*options)
      factory_name, params = parse_create_options(options)
      
      ObjectCreator.create_object(factory_name, params, factories_store, sequencer)
    end
    
    def create_graph(*options)
      factory_name, params = parse_create_options(options)
    
      graph_creator = GraphCreator.new(factory_name, params, factories_store, sequencer)
      graph_creator.create_graph
    
      graph_creator.graph
    end
    
    def create_list(num, *options)
      factory_name, params = parse_create_options(options)
      
      list_creator = ListCreator.new(num, factory_name, params, factories_store, sequencer)
      list_creator.create_list
      
      list_creator.list
    end
    
    def define_factories(&block)
      instance_exec(&block)
    end
    
    alias :factories :define_factories
    
    def define_factory(factory_name, *options)
      parent_factory_name, params = parse_factory_options(options)
    
      factories_store.define_factory(factory_name, parent_factory_name, params)
    end
    
    alias :factory :define_factory
    
    def undefine_all_factories
      factories_store.undefine_all_factories
    end
    
    def factories_count
      factories_store.factories_count
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