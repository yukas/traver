$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "traver"

require "bundler/setup"
require "minitest/autorun"
require "support/class_definer_helper"
require "support/ar_class_definer_helper"
require "active_record"

class Minitest::Test
  include Traver
end