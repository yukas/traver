require "forwardable"

module Traver
  class ObjectCreator
    extend Forwardable
    
    attr_reader :factory_name, :params, :settings, :cache
    attr_reader :object
    
    attr_accessor :after_create
    
    def_delegators :settings, :factory_definer,
                              :object_persister,
                              :attributes_resolver,
                              :default_params_creator
    
    def initialize(factory_name, params, settings, cache = {})
      @factory_name = factory_name
      @params       = params
      @settings     = settings
      @cache        = cache
    end
    
    def create_object
      obtain_factory
      
      if obtain_object_from_cache?
        obtain_object_from_cache
      else
        merge_params_with_factory_params
        merge_default_params
        instantiate_object
        set_attributes
        set_nested_objects
        persist_object
        set_nested_collections
        call_after_create_hook
      end
    end
    
    private
    attr_reader :factory
    
    def obtain_object_from_cache?
      params == {} && cache.has_key?(factory.root_name)
    end
    
    def obtain_object_from_cache
      @object = cache[factory.root_name]
    end
    
    def obtain_factory
      @factory = factory_definer.factory_by_name(factory_name)
    end
    
    def merge_params_with_factory_params
      @params = factory.inherited_params.merge(params)
    end
    
    def merge_default_params
      @params = default_params_creator.default_params(factory.object_class).merge(params)
    end
    
    def instantiate_object
      @object = factory.object_class.new
    end
    
    # Attributes
    
    def set_attributes
      attributes_resolver.select_attributes_params(params, factory.object_class).each do |name, value|
        set_attribute(name, value)
      end
    end
    
    def set_attribute(attribute, value)
      value = value.call if value.is_a?(Proc)

      object.public_send("#{attribute}=", value)
    end
    
    # Nested Objects
    
    def set_nested_objects
      attributes_resolver.select_objects_params(params, factory.object_class).each do |name, value|
        set_nested_object(name, value)
      end
    end
    
    def set_nested_object(name, value)
      if value.is_a?(Hash)
        set_attribute(name, create_nested_object(name, value))
      else
        set_attribute(name, value)
      end
    end
    
    def create_nested_object(factory_name, params)
      object_creator = ObjectCreator.new(factory_name, params, settings, cache)
      object_creator.after_create = after_create
      object_creator.create_object
      
      object_creator.object
    end
    
    
    # Nested Collections
    
    def set_nested_collections
      attributes_resolver.select_collections_params(object, factory, params).each do |name, value|
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
    
    
    # Persist Object
    
    def persist_object
      object_persister.persist_object(object)
      cache[factory.root_name] = object
    end
    
    
    # Hooks
    
    def call_after_create_hook
      after_create.call(self) if after_create
    end
  end
end