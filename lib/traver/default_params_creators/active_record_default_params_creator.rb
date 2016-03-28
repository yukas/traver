module Traver
  class ActiveRecordDefaultParamsCreator
    def default_params(object_class)
      associations = object_class.reflect_on_all_associations(:belongs_to)
      
      associations.each_with_object({}) do |association, result|
        result[association.name] = :__ref__
      end
    end
  end
end