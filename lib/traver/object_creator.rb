require "forwardable"

module Traver
  class ObjectCreator
    extend Forwardable
    
    attr_reader :factory_name, :params, :settings
    attr_reader :object
    
    attr_accessor :after_create
    
    def_delegators :settings, :factory_definer,
                              :object_persister,
                              :attribute_resolver,
                              :nested_object_resolver,
                              :nested_collection_resolver
    
    def initialize(factory_name, params, settings)
      @factory_name = factory_name
      @params       = params
      @settings     = settings
    end
    
    def create_object
      obtain_factory
      merge_params_with_factory_params
      instantiate_object
      set_object_state
      persist_object
      call_after_create_hook
    end
    
    private
    attr_reader :factory, :merged_params
    
    def obtain_factory
      @factory = factory_definer.factory_by_name(factory_name)
    end
    
    def merge_params_with_factory_params
      @merged_params = factory.inherited_params.merge(params)
    end
    
    def instantiate_object
      @object = factory.object_class.new
    end
    
    def set_object_state
      set_attributes
      set_nested_objects
      set_nested_collections
    end

    # Attributes
    
    def set_attributes
      attribute_resolver.select_attributes_params(merged_params, factory.object_class).each do |name, value|
        set_attribute(name, value)
      end
    end
    
    def set_attribute(attribute, value)
      object.public_send("#{attribute}=", value)
    end
    
    # Nested Objects
    
    def set_nested_objects
      nested_object_resolver.select_objects_params(merged_params, factory.object_class).each do |name, value|
        set_nested_object(name, value)
      end
    end
    
    def set_nested_object(name, value)
      set_attribute(name, create_nested_object(name, value))
    end
    
    def create_nested_object(factory_name, params)
      object_creator = ObjectCreator.new(factory_name, params, settings)
      object_creator.after_create = after_create
      object_creator.create_object
      
      object_creator.object
    end
    
    
    # Nested Collections
    
    def set_nested_collections
      nested_collection_resolver.select_nested_collections_params(merged_params, factory.object_class).each do |name, value|
        set_nested_collection(name, value)
      end
    end
    
    def set_nested_collection(name, value)
      set_attribute(name, create_nested_collection(name, value))
    end
    
    def create_nested_collection(factory_name, collection_params)
      collection_params.map do |params|
        create_nested_object(factory_name.to_s.singularize.to_sym, params)
      end
    end
    
    
    
    def persist_object
      object_persister.persist_object(object)
    end
    
    def call_after_create_hook
      after_create.call(self) if after_create
    end
  end
end