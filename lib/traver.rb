require "active_support/inflector"

Dir["#{File.dirname(__FILE__)}/traver/**/*.rb"].each { |file| require file }

module Traver
  class Error < Exception; end
  
  class << self
    def create(*args)
      load_factories
      
      traver_constructor.create(*args)
    end
  
    def create_graph(*args)
      load_factories
      
      traver_constructor.create_graph(*args)
    end
    
    def create_list(*args)
      load_factories
      
      traver_constructor.create_list(*args)
    end
    
    def define_factory(*args)
      traver_constructor.define_factory(*args)
    end

    def define_factories(&block)
      traver_constructor.define_factories(&block)
    end
  
    def undefine_all_factories
      traver_constructor.undefine_all_factories
    end

    alias :factory   :define_factory    
    alias :factories :define_factories

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