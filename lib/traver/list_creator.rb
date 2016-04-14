module Traver
  class ListCreator
    attr_reader :num, :factory_name, :params, :factory_store, :sequencer
    attr_reader :list
    
    def initialize(num, factory_name, params, factory_store, sequencer)
      @num             = num
      @factory_name    = factory_name
      @params          = params
      @factory_store = factory_store
      @sequencer       = sequencer
    end
    
    def create_list
      @list = num.times.map do
        object_creator.create_object(factory_name, params, factory_store, sequencer)
      end
    end
    
    private
    
    def object_creator
      ObjectCreator
    end
  end
end