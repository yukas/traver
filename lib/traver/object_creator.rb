require "forwardable"

module Traver
  class ObjectCreator
    extend Forwardable
    
    attr_reader :factory_name, :params, :settings, :cache, :nesting
    attr_reader :object
    
    attr_accessor :after_create
    
    def_delegators :settings, :factory_definer,
                              :object_persister,
                              :attributes_resolver,
                              :default_params_creator,
                              :sequencer
    
    def self.create_object(factory_name, params, settings, cache = {})
      creator = new(factory_name, params, settings, cache)
      creator.create_object
      
      creator.object
    end
    
    def initialize(factory_name, params, settings, cache = {}, nesting = 1)
      @factory_name = factory_name
      @params       = params
      @settings     = settings
      @cache        = cache
      @nesting      = nesting
    end
    
    def create_object
      obtain_factory
      
      if obtain_object_from_cache?
        obtain_object_from_cache
      else
        # puts "#{'-' * nesting} #{factory_name}<br/>"
        
        change_ref_to_be_empty_hash
        merge_factory_params
        merge_default_params
        instantiate_object
        set_nested_objects
        set_attributes
        persist_object
        set_has_one_objects
        set_nested_collections
        call_after_create_hook
      end
    end
    
    private
    attr_reader :factory
    
    def obtain_factory
      @factory = factory_definer.factory_by_name(factory_name)
    end
    
    def obtain_object_from_cache?
      params == :__ref__ && cache.has_key?(factory.root_name)
    end
    
    def obtain_object_from_cache
      @object = cache[factory.root_name]
    end
    
    def change_ref_to_be_empty_hash
      @params = {} if params == :__ref__
    end
    
    def merge_factory_params
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
      if value.is_a?(Proc)
        value = object.instance_exec(&value)
      elsif value.is_a?(String)
        if sequencer.value_has_sequence?(value)
          value = sequencer.interpolate_sequence(attribute, value)
        end
      end
      
      object.public_send("#{attribute}=", value)
    end
    
    # Nested Objects
    
    def set_nested_objects
      attributes_resolver.select_objects_params(params, factory.object_class).each do |name, value|
        set_nested_object(name, value)
      end
    end
    
    def set_nested_object(name, value)
      if value.is_a?(Integer)
        set_attribute(name, create_nested_object(name, {}))
      elsif value.is_a?(Hash) || value == :__ref__
        set_attribute(name, create_nested_object(name, value))
      elsif value.is_a?(Symbol)
        set_attribute(name, create_nested_object(value, {}))
      else
        set_attribute(name, value)
      end
    end
    
    def create_nested_object(factory_name, params)
      object_creator = ObjectCreator.new(factory_name, params, settings, cache, nesting + 1)
      object_creator.after_create = after_create
      object_creator.create_object
      
      object_creator.object
    end
    
    
    # Has one objects
    
    def set_has_one_objects
      attributes_resolver.select_has_one_objects_params(params, factory.object_class).each do |name, value|
        set_nested_object(name, value)
      end
    end
    
    # Nested Collections
    
    def set_nested_collections
      attributes_resolver.select_collections_params(object, factory, params).each do |collection_name, params_array|
        set_nested_collection(collection_name, params_array)
      end
    end
    
    def set_nested_collection(collection_name, params_array)
      factory_name = collection_name.to_s.singularize.to_sym
      
      set_attribute(collection_name, create_nested_collection(factory_name, params_array))
    end
    
    def create_nested_collection(factory_name, params_array)
      if params_array.is_a?(Integer)
        params_array = [{}] * params_array
        
        params_array.map do |params|
          create_nested_object(factory_name, params)
        end
      elsif params_array.first.is_a?(Symbol)
        params_array.map do |factory_name|
          create_nested_object(factory_name, {})
        end
      else
        if params_array.first.is_a?(Integer)
          num, hash_or_symbol = params_array
        
          if hash_or_symbol.nil?
            params_array = [{}] * num
          elsif (hash = hash_or_symbol).is_a?(Hash)
            params_array = [hash] * num
          elsif hash_or_symbol.is_a?(Symbol)
            factory_name = hash_or_symbol
          
            params_array = [{}] * num
          else
            raise "Wrong collection params #{params_array}"
          end
        end
      
        params_array.map do |params|
          create_nested_object(factory_name, params)
        end
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
