module Traver
  class GraphCreator
    attr_reader :object_creator
    attr_reader :graph
    
    def initialize(object_creator)
      @object_creator = object_creator
      @graph = Graph.new
    end
    
    def create_graph
      object_creator.after_create = lambda do |creator|
        graph.add_vertex(creator.factory_name, creator.created_object)
      end
      
      object_creator.create_object
    end
  end
end
