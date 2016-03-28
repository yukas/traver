module Traver
  class ListCreator
    attr_reader :num, :factory_name, :params, :settings
    attr_reader :list
    
    def initialize(num, factory_name, params, settings)
      @num          = num
      @factory_name = factory_name
      @params       = params
      @settings     = settings
    end
    
    def create_list
      @list = num.times.map do
        object_creator.create_object(factory_name, params, settings)
      end
    end
    
    private
    
    def object_creator
      ObjectCreator
    end
  end
end