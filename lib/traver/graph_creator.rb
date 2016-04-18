module Traver
  class GraphCreator
    attr_reader :factory_name, :params, :factories_store, :sequencer
    attr_reader :graph
    
    def initialize(factory_name, params, factories_store, sequencer)
      @factory_name    = factory_name
      @params          = params
      @factories_store = factories_store
      @sequencer       = sequencer
      
      @object_creator = ObjectCreator.new(factory_name, params, factories_store, sequencer)
      
      @graph = Graph.new
    end
    
    def create_graph
      object_creator.after_create = lambda do |creator|
        graph.add_vertex(creator.factory_name, creator.object)
      end
      
      object_creator.create_object
    end
    
    private
    attr_reader :object_creator
  end
end
