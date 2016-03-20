require "active_support/inflector"
require "traver/version"
require "traver/factory_definer"
require "traver/factory"
require "traver/object_creator"
require "traver/graph"
require "traver/graph_creator"
require "traver/object_persisters/active_record_object_persister"
require "traver/object_persisters/poro_object_persister"
require "traver/factories_loader"
require "traver/attribute_resolvers/poro_attribute_resolver"
require "traver/nested_object_resolvers/poro_nested_object_resolver"
require "traver/nested_object_resolvers/active_record_nested_object_resolver"
require "traver/nested_collection_resolvers/active_record_nested_collection_resolver"
require "traver/nested_collection_resolvers/poro_nested_collection_resolver"
require "traver/traver_constructor"
require "traver/settings/poro_settings"
require "traver/settings/active_record_settings"

module Traver
  class Error < Exception; end
  
  class << self
    def define_factory(factory_name, *options)
      traver_constructor.define_factory(factory_name, *options)
    end
  
    def create(options)
      traver_constructor.create(options)
    end
  
    def create_graph(options)
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
        RailsSettings.new
      else
        PoroSettings.new
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