module Traver
  class ObjectCreator
    attr_reader :factory_name, :params, :factory_definer, :object_persister
    attr_reader :created_object
    
    attr_accessor :after_create
    
    def initialize(factory_name, params, factory_definer, object_persister)
      @factory_name = factory_name
      @params = params
      @factory_definer = factory_definer
      @object_persister = object_persister
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
      factory_params.each do |attribute, value|
        if nested_params?(value)
          create_nested_object(attribute, value)
        elsif collection_params?(value)
          create_collection(attribute, value)
        else
          set_attribute(attribute, value)
        end
      end
    end
    
    def factory_params
      factory.inherited_params.merge(params)
    end
    
    def nested_params?(params)
      params.is_a?(Hash)
    end
    
    def create_nested_object(k, v)
      set_attribute(k, do_create_object(k, v))
    end
    
    def do_create_object(factory_name, params)
      object_creator = ObjectCreator.new(factory_name, params, factory_definer, object_persister)
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