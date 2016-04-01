module Traver
  class ListCreator
    attr_reader :num, :factory_name, :params, :factory_definer, :sequencer
    attr_reader :list
    
    def initialize(num, factory_name, params, factory_definer, sequencer)
      @num             = num
      @factory_name    = factory_name
      @params          = params
      @factory_definer = factory_definer
      @sequencer       = sequencer
    end
    
    def create_list
      @list = num.times.map do
        object_creator.create_object(factory_name, params, factory_definer, sequencer)
      end
    end
    
    private
    
    def object_creator
      ObjectCreator
    end
  end
end