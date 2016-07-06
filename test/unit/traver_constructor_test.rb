require "test_helper"

class TraverConstructorTest < TraverTest
  attr_reader :subject
  
  def setup
    super
    
    @subject = TraverConstructor.new
  end
  
  module Foo
    def foo
      :foo
    end
  end
  
  def test_includes_module
    subject.include(Foo)
    
    assert_equal :foo, subject.foo
  end
end