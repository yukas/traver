module Traver
  class ActiveRecordObjectPersister
    def persist_object(object)
      object.save
    end
  end
end