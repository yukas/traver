module Traver
  class GraphCreator
    attr_reader :factory_name, :params, :factory_definer
    attr_reader :graph
    
    def initialize(factory_name, params, factory_definer)
      @factory_name = factory_name
      @params = params
      @factory_definer = factory_definer
      
      @graph = Graph.new
    end
    
    def create_graph
      object_creator = ObjectCreator.new(factory_name, params, factory_definer)
      object_creator.after_create = lambda do |creator|
        graph.add_vertex(creator.factory_name, creator.created_object)
      end
      
      object_creator.create_object
    end
  end
end
