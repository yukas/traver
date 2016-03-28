require "traver/settings"

module Traver
  class PoroSettings < Settings
    def initialize
      super
      
      @object_persister       = PoroObjectPersister.new
      @attributes_resolver    = PoroAttributesResolver.new
      @default_params_creator = PoroDefaultParamsCreator.new
    end
  end
end