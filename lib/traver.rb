require "active_support/inflector"
require "traver/version"
require "traver/factory_definer"
require "traver/factory"
require "traver/object_creator"
require "traver/graph"
require "traver/graph_creator"
require "traver/object_persisters/active_record_object_persister"
require "traver/object_persisters/poro_object_persister"

module Traver
  class Error < Exception; end
  
  class << self
    attr_accessor :factory_definer, :object_persister
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
    options = { options => {} } if options.is_a?(Symbol)
    
    object_creator = ObjectCreator.new(*options.first, factory_definer, object_persister)
    object_creator.create_object
    
    object_creator.created_object
  end
  
  def self.create_graph(options)
    options = { options => {} } if options.is_a?(Symbol)
    
    object_creator = ObjectCreator.new(*options.first, factory_definer, object_persister)
    graph_creator = GraphCreator.new(object_creator)
    graph_creator.create_graph
    
    graph_creator.graph
  end
  
  def self.load_factories(base_dir_string, test_folder_name = "test")
    factories_file_path = File.join(base_dir_string, test_folder_name, "factories.rb")
    
    require factories_file_path
  end
end