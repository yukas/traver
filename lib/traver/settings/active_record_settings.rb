require "traver/settings"

module Traver
  class ActiveRecordSettings < Settings
    def initialize
      super
      
      @object_persister           = ActiveRecordObjectPersister.new
      @nested_object_resolver     = ActiveRecordNestedObjectResolver.new
      @nested_collection_resolver = ActiveRecordNestedCollectionResolver.new
    end
  end
end