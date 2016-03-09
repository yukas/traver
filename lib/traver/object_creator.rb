module Traver
  class ObjectCreator
    attr_reader :factory_name, :params
    attr_reader :created_object
    
    def initialize(options)
      options = { options => {} } if options.is_a?(Symbol)
      
      @factory_name, @params = options.first
      @factory_definer = FactoryDefiner.instance
    end
    
    def create_object
      instantiate_object
      set_object_state
      persist_object
    end
    
    private
    attr_reader :factory_definer
    
    def instantiate_object
      @created_object = get_class.new
    end
    
    def get_class
      factory_definer.get_object_class(factory_name)
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
      factory_definer.apply_factory_params(factory_name, params)
    end
    
    def nested_params?(params)
      params.is_a?(Hash)
    end
    
    def create_nested_object(k, v)
      set_attribute(k, do_create_object(k => v))
    end
    
    def do_create_object(params)
      object_creator = ObjectCreator.new(params)
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
        do_create_object(singularize(attribute) => params)
      end
      
      set_attribute(attribute, collection)
    end
    
    def singularize(val)
      val.to_s.chomp("s").to_sym
    end
    
    def persist_object
      created_object.save if defined?(Rails)
    end
  end
end