$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "traver"

require "minitest/autorun"
require "support/class_definer_helper"

class Minitest::Test
  include ClassDefinerHelper
end