require "traver/version"
require "traver/factory_definer"
require "traver/object_creator"

module Traver
  def self.factory(class_name, params)
    factory_definer = FactoryDefiner.instance
    factory_definer.define_factory(class_name, params)
  end
  
  def self.create(options)
    object_creator = ObjectCreator.new(options)
    object_creator.create_object
    
    object_creator.created_object
  end
end
