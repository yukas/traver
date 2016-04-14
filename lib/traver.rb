require "active_support/inflector"

Dir["#{File.dirname(__FILE__)}/traver/**/*.rb"].each { |file| require file }

module Traver
  class Error < Exception; end
  
  class << self
    def create(*options)
      load_factories
      
      traver_constructor.create(*options)
    end
  
    def create_graph(*options)
      load_factories
      
      traver_constructor.create_graph(*options)
    end
    
    def create_list(num, *options)
      load_factories
      
      traver_constructor.create_list(num, *options)
    end
    
    def define_factory(factory_name, *options)
      traver_constructor.define_factory(factory_name, *options)
    end

    alias :factory :define_factory
    
    def define_factories(&block)
      traver_constructor.define_factories(&block)
    end
    
    alias :factories :define_factories
  
    def undefine_all_factories
      traver_constructor.undefine_all_factories
    end
    
    private
    
    def traver_constructor
      @traver_constructor ||= TraverConstructor.new
    end
    
    def load_factories
      factories_loader.load_factories
    end
    
    def factories_loader
      @factories_loader ||= FactoriesLoader.new(Dir.getwd)
    end
  end
end