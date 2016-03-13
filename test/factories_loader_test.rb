require "test_helper"

class FactoriesLoaderTest < TraverTest
  def test_load_factories_from_test_directory
    define_class("User", :name)
    factories_loader = FactoriesLoader.new(File.join(Dir.pwd, "test", "support", "dummy"), "test")
    
    factories_loader.load_factories
    user = Traver.create(:user)

    assert_equal "Walter Test", user.name
  end

  def test_load_factories_from_spec_directory
    define_class("User", :name)
    factories_loader = FactoriesLoader.new(File.join(Dir.pwd, "test", "support", "dummy"), "spec")

    factories_loader.load_factories
    user = Traver.create(:user)

    assert_equal "Walter Spec", user.name
  end
end