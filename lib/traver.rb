require "active_support"
require "traver/version"
require "traver/factory_definer"
require "traver/object_creator"
require "traver/graph"
require "traver/graph_creator"

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
  
  def self.create_graph(params = {})
    graph_creator = GraphCreator.new(params)
    graph_creator.create_graph
    
    graph_creator.graph
  end
  
  def self.load_factories(base_dir_string, test_folder_name = "test")
    factories_file_path = File.join(base_dir_string, test_folder_name, "factories.rb")
    
    require factories_file_path
  end
end