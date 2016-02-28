require "traver/version"

module Traver
  def self.factories
    @factories ||= {}
  end

  def self.factory(class_name, params)
    factories[class_name] = params
  end
  
  def self.create(options)
    if options.is_a?(Symbol)
      class_name = options
      params = factories[class_name]
    elsif options.is_a?(Hash)
      class_name, params = options.first
      params = factories[class_name].merge(params) if factories[class_name]
    end
    
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
