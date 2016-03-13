require "active_support/inflector"
require "traver/version"
require "traver/factory_definer"
require "traver/factory"
require "traver/object_creator"
require "traver/graph"
require "traver/graph_creator"
require "traver/object_persisters/active_record_object_persister"
require "traver/object_persisters/poro_object_persister"
require "traver/factories_loader"

module Traver
  class Error < Exception; end
  
  class << self
    attr_accessor :factory_definer, :object_persister, :factories_loader
  end
  
  def self.define_factory(factory_name, *options)
    parent_name = nil
    
    if options.size == 1
      params = options.first
    elsif options.size == 2
      parent_name, params = options
    end
    
    factory_definer.define_factory(factory_name, parent_name, params)
  end
  
  def self.create(options)
    factories_loader.load_factories
    
    options = { options => {} } if options.is_a?(Symbol)
    
    object_creator = ObjectCreator.new(*options.first, factory_definer, object_persister)
    object_creator.create_object
    
    object_creator.created_object
  end
  
  def self.create_graph(options)
    factories_loader.load_factories
    
    options = { options => {} } if options.is_a?(Symbol)
    
    object_creator = ObjectCreator.new(*options.first, factory_definer, object_persister)
    graph_creator = GraphCreator.new(object_creator)
    graph_creator.create_graph
    
    graph_creator.graph
  end
end