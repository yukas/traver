require "traver/settings"

module Traver
  class PoroSettings < Settings
    def initialize
      super
      
      @object_persister           = PoroObjectPersister.new
      @nested_object_resolver     = PoroNestedObjectResolver.new
      @nested_collection_resolver = PoroNestedCollectionResolver.new
    end
  end
end