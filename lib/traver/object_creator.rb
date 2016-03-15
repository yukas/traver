module Traver
  class ObjectCreator
    attr_reader :factory_name, :params, :factory_definer,
                :object_persister, :nested_object_resolver,
                :nested_collection_resolver
    attr_reader :created_object
    
    attr_accessor :after_create
    
    def initialize(factory_name, params, factory_definer, object_persister, nested_object_resolver, nested_collection_resolver)
      @factory_name = factory_name
      @params = params
      @factory_definer = factory_definer
      @object_persister = object_persister
      @nested_object_resolver = nested_object_resolver
      @nested_collection_resolver = nested_collection_resolver
    end
    
    def create_object
      instantiate_object
      set_object_state
      persist_object
      call_after_create_hook
    end
    
    private
    attr_reader :factory, :factory_params, :object_class

    def instantiate_object
      @factory = factory_definer.factory_by_name(factory_name)
      @factory_params = factory.inherited_params.merge(params)
      @object_class = Object.const_get(factory.root_factory.name.to_s.camelize)
      @created_object = object_class.new
    end
    
    def set_object_state
      set_attributes
      set_nested_objects
      set_nested_collections
    end

    # Attributes
    
    def set_attributes
      attributes_params.each { |name, value| set_attribute(name, value) }
    end
    
    def attributes_params
      factory_params.select { |k, v| regular_attribute?(k, v) }
    end
    
    def regular_attribute?(field_name, field_value)
      !nested_object?(field_name, field_value) && !nested_collection?(field_name, field_value)
    end
    
    def set_attribute(attribute, value)
      created_object.public_send("#{attribute}=", value)
    end
    
    
    # Nested Objects
    
    def set_nested_objects
      nested_objects_params.each do |field_name, field_value|
        set_nested_object(field_name, field_value)
      end
    end
    
    def nested_objects_params
      factory_params.select { |k, v| nested_object?(k, v) }
    end
    
    def nested_object?(field_name, field_value)
      nested_object_resolver.nested_object?(object_class, field_name, field_value)
    end
    
    def set_nested_object(k, v)
      set_attribute(k, create_nested_object(k, v))
    end
    
    def create_nested_object(factory_name, params)
      object_creator = ObjectCreator.new(factory_name, params, factory_definer, object_persister, nested_object_resolver, nested_collection_resolver)
      object_creator.after_create = after_create
      object_creator.create_object
      
      object_creator.created_object
    end
    
    
    # Nested Collections
    
    def set_nested_collections
      nested_collections_params.each do |name, value|
        set_nested_collection(name, value)
      end
    end
    
    def nested_collections_params
      factory_params.select { |k, v| nested_collection?(k, v) }
    end
    
    def nested_collection?(field_name, field_value)
      nested_collection_resolver.nested_collection?(object_class, field_name, field_value)
    end
    
    def set_nested_collection(attribute, collection_params)
      set_attribute(attribute, create_nested_collection(attribute, collection_params))
    end
    
    def create_nested_collection(factory_name, collection_params)
      collection_params.map do |params|
        create_nested_object(factory_name.to_s.singularize.to_sym, params)
      end
    end
    
    def persist_object
      object_persister.persist_object(created_object)
    end
    
    def call_after_create_hook
      after_create.call(self) if after_create
    end
  end
end