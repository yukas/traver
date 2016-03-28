module Traver
  class ActiveRecordObjectPersister
    def persist_object(object)
      unless object.save
        raise "Unable to save #{object.class}: #{object.errors.full_messages}"
      end
    end
  end
end