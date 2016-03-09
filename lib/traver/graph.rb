module Traver
  class Graph
    def initialize
      @vertices = {}
    end
    
    def add_vertex(key, object)
      vertices[key] ||= []
      vertices[key] << object
    end
    
    def [](key)
      key = key.to_s
      
      if plural?(key)
        vertices[singularize(key).to_sym]
      else
        name, index = key.split(/(\d+)$/)
        index = (index || 1).to_i
      
        vertices[name.to_sym][index - 1]
      end
    end
    
    def method_missing(method_name, *args)
      self[method_name]
    end
    
    private
    attr_reader :vertices
    
    def plural?(value)
      value.end_with?("s")
    end
    
    def singularize(value)
      value.chomp("s")
    end
  end
end