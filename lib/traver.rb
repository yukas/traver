require "traver/version"

module Traver
  def self.create(class_name)
    klass = Object.const_get(class_name.to_s.capitalize)
    
    klass.new
  end
end
