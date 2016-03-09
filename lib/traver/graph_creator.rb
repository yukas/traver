module Traver
  class GraphCreator
    attr_reader :params
    attr_reader :graph
    
    def initialize(params = {})
      @params = params
      @graph = Graph.new
    end
    
    def create_graph
      object_creator = ObjectCreator.new(params)
      object_creator.after_create = lambda do |creator|
        graph.add_vertex(creator.factory_name, creator.created_object)
      end
      
      object_creator.create_object
    end
  end
end
