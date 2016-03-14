module Traver
  class ObjectCreator
    attr_reader :factory_name, :params, :factory_definer, :object_persister, :nested_object_resolver
    attr_reader :created_object
    
    attr_accessor :after_create
    
    def initialize(factory_name, params, factory_definer, object_persister, nested_object_resolver)
      @factory_name = factory_name
      @params = params
      @factory_definer = factory_definer
      @object_persister = object_persister
      @nested_object_resolver = nested_object_resolver
    end
    
    def create_object
      instantiate_object
      set_object_state
      persist_object
      call_after_create_hook
    end
    
    private

    def instantiate_object
      @created_object = get_class.new
    end
    
    def get_class
      Object.const_get(factory.root_factory.name.to_s.camelize)
    end
    
    def factory
      @factory ||= factory_definer.factory_by_name(factory_name)
    end
    
    def set_object_state
      factory_params.each do |field_name, field_value|
        if nested_object?(field_name, field_value)
          create_nested_object(field_name, field_value)
        elsif collection_params?(field_value)
          create_collection(field_name, field_value)
        else
          set_attribute(field_name, field_value)
        end
      end
    end
    
    def factory_params
      factory.inherited_params.merge(params)
    end
    
    def nested_object?(field_name, field_value)
      nested_object_resolver.nested_object?(get_class, field_name, field_value)
    end
    
    def create_nested_object(k, v)
      set_attribute(k, do_create_object(k, v))
    end
    
    def do_create_object(factory_name, params)
      object_creator = ObjectCreator.new(factory_name, params, factory_definer, object_persister, nested_object_resolver)
      object_creator.after_create = after_create
      object_creator.create_object
      
      object_creator.created_object
    end
    
    def set_attribute(attribute, value)
      created_object.public_send("#{attribute}=", value)
    end
    
    def collection_params?(params)
      params.is_a?(Array)
    end
    
    def create_collection(attribute, collection_params)
      collection = collection_params.map do |params|
        do_create_object(attribute.to_s.singularize.to_sym, params)
      end
      
      set_attribute(attribute, collection)
    end
    
    def persist_object
      object_persister.persist_object(created_object)
    end
    
    def call_after_create_hook
      after_create.call(self) if after_create
    end
  end
end