require "bundler/setup"
require "minitest/autorun"
require "support/class_definer"
require "support/model_definer"
require "traver_test"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "traver"