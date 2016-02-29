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
      klass = factory_definer.get_object_class(factory_name)
      @created_object = klass.new
      
      factory_params = factory_definer.apply_factory_params(factory_name, params)
      
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