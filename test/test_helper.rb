$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'traver'

require 'minitest/autorun'

def define_class(class_name)
  Object.const_set(class_name.to_s.capitalize, Class.new)
end
