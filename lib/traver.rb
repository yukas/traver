require "traver/version"

module Traver
  def self.create(options)
    if options.is_a?(Symbol)
      klass = Object.const_get(options.to_s.capitalize)
      
      klass.new
    elsif options.is_a?(Hash)
      class_name, params = options.first
      
      klass = Object.const_get(class_name.to_s.capitalize)
      object = klass.new
      
      params.each do |k, v|
        object.public_send("#{k}=", v)
      end
      
      object
    end
  end
end
