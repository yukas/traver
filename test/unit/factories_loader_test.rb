require "test_helper"

class FactoriesLoaderTest < TraverTest
  attr_reader :subject
  
  def setup
    super
    
    @subject = FactoriesLoader.new("/base/dir")
  end
  
  def test_load_factories
    file_class    = MiniTest::Mock.new
    kernel_module = MiniTest::Mock.new
    
    4.times { file_class.expect(:exist?, true, [String]) }
    
    kernel_module.expect(:require, Object, ["/base/dir/test/factories.rb"])
    kernel_module.expect(:require, Object, ["/base/dir/test/traver_factories.rb"])
    kernel_module.expect(:require, Object, ["/base/dir/spec/factories.rb"])
    kernel_module.expect(:require, Object, ["/base/dir/spec/traver_factories.rb"])

    subject.stub(:kernel_module, kernel_module) do
      subject.stub(:file_class, file_class) do
        subject.load_factories
      end
    end
    
    assert kernel_module.verify
    assert file_class.verify
    
    assert subject.factories_loaded
  end
end