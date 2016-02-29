module Traver
  class ObjectCreator
    attr_reader :class_name, :params
    attr_reader :created_object
    
    def initialize(options)
      options = { options => {} } if options.is_a?(Symbol)
      
      @class_name, @params = options.first
      @factory_definer = FactoryDefiner.instance
    end
    
    def create_object
      klass = Object.const_get(class_name.to_s.capitalize)
      @created_object = klass.new
      
      factory_params = factory_definer.apply_factory_params(class_name, params)
      
      set_object_state(factory_params)
    end
    
    private
    attr_reader :factory_definer
    
    def set_object_state(params)
      params.each do |k, v|
        created_object.public_send("#{k}=", v)
      end
    end
  end
end