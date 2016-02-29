require "traver/version"
require "traver/factory_definer"
require "traver/object_creator"

module Traver
  class Error < Exception; end
  
  def self.factory(factory_name, *options)
    factory_definer = FactoryDefiner.instance
    factory_definer.define_factory(factory_name, *options)
  end
  
  def self.create(options)
    object_creator = ObjectCreator.new(options)
    object_creator.create_object
    
    object_creator.created_object
  end
end
