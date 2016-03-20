require "traver/settings"

module Traver
  class ActiveRecordSettings < Settings
    def initialize
      super
      
      @object_persister    = ActiveRecordObjectPersister.new
      @attributes_resolver = ActiveRecordAttributesResolver.new
    end
  end
end