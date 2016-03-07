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
      @created_object = instantiate_object(get_class)
      
      set_object_state(apply_factory)
    end
    
    private
    attr_reader :factory_definer
    
    def get_class
      factory_definer.get_object_class(factory_name)
    end
    
    def instantiate_object(klass)
      klass.new
    end
    
    def apply_factory
      factory_definer.apply_factory_params(factory_name, params)
    end
    
    def set_object_state(params)
      params.each do |attribute, value|
        if nested_params?(value)
          create_nested_object(attribute, value)
        else
          set_attribute(attribute, value)
        end
      end
    end
    
    def nested_params?(val)
      val.is_a?(Hash)
    end
    
    def create_nested_object(k, v)
      object_creator = ObjectCreator.new(k => v)
      object_creator.create_object
      
      set_attribute(k, object_creator.created_object)
    end
    
    def set_attribute(attribute, value)
      created_object.public_send("#{attribute}=", value)
    end
  end
end