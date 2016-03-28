require "active_support/inflector"

Dir["#{File.dirname(__FILE__)}/traver/**/*.rb"].each { |file| require file }

module Traver
  class Error < Exception; end
  
  class << self
    attr_reader :factories_loaded
    
    def define_factory(factory_name, *options)
      traver_constructor.define_factory(factory_name, *options)
    end
  
    def create(options)
      load_factories
      
      traver_constructor.create(options)
    end
  
    def create_graph(options)
      load_factories
      
      traver_constructor.create_graph(options)
    end
    
    def undefine_all_factories
      traver_constructor.undefine_all_factories
    end
    
    private
    
    def traver_constructor
      @traver_constructor ||= TraverConstructor.new(settings)
    end
    
    def settings
      if defined?(Rails)
        ActiveRecordSettings.new
      else
        PoroSettings.new
      end
    end
    
    def load_factories
      unless factories_loaded
        factories_loader.load_factories

        @factories_loader = true
      end
    end
    
    def factories_loader
      if defined?(Rails)
        FactoriesLoader.new(Rails.root, "spec")
      else
        NilFactoriesLoader.new
      end
    end
  end
end