require "traver/settings"

module Traver
  class PoroSettings < Settings
    def initialize
      super
      
      @object_persister    = PoroObjectPersister.new
      @attributes_resolver = PoroAttributesResolver.new
    end
  end
end