module Traver
  class Settings
    attr_reader :factory_definer,
                :object_persister,
                :attribute_resolver,
                :nested_object_resolver,
                :nested_collection_resolver
    
    def initialize
      @factory_definer = FactoryDefiner.new
      @attribute_resolver = PoroAttributeResolver.new
    end            
    
    def define_factory(factory_name, parent_factory_name, params)
      factory_definer.define_factory(factory_name, parent_factory_name, params)
    end

    def undefine_all_factories
      factory_definer.undefine_all_factories
    end
  end
end