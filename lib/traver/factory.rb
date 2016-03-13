module Traver
  class Factory
    attr_reader :name, :params, :parent_factory
    
    def initialize(name, params, parent_factory)
      @name   = name
      @params = params
      @parent_factory = parent_factory
    end
    
    def root_factory
      parent_factory ? parent_factory.root_factory : self
    end

    def inherited_params
      if parent_factory
        parent_factory.inherited_params.merge(params)
      else
        params
      end
    end
  end
end