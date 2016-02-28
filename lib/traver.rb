require "traver/version"
require "traver/factory_definer"

module Traver
  def self.factory(class_name, params)
    factory_definer = FactoryDefiner.instance
    factory_definer.define_factory(class_name, params)
  end
  
  def self.create(options)
    options = { options => {} } if options.is_a?(Symbol)
    
    class_name, params = options.first
    
    factory_definer = FactoryDefiner.instance
    params = factory_definer.apply_factory_params(class_name, params)
    
    create_object(class_name, params)
  end
  
  def self.create_object(class_name, params)
    klass = Object.const_get(class_name.to_s.capitalize)
    object = klass.new
    
    set_object_state(object, params)
    
    object
  end
  
  def self.set_object_state(object, params)
    params = Array(params)
    
    params.each do |k, v|
      object.public_send("#{k}=", v)
    end
  end
end
