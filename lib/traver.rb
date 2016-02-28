require "traver/version"

module Traver
  def self.create(options)
    if options.is_a?(Symbol)
      create_bare_object(options)
    elsif options.is_a?(Hash)
      create_object_with_attributes(*options.first)
    end
  end
  
  def self.create_bare_object(class_name)
    klass = Object.const_get(class_name.to_s.capitalize)
    
    klass.new
  end
  
  def self.create_object_with_attributes(class_name, attributes)
    klass = Object.const_get(class_name.to_s.capitalize)
    object = klass.new
    
    attributes.each do |k, v|
      object.public_send("#{k}=", v)
    end
    
    object
  end
end
