require "test_helper"

class ListCreatorTest < TraverTest
  attr_reader :subject
  attr_reader :object_creator
  
  def setup
    super
    
    define_class("User", :name)
    
    @object_creator = MiniTest::Mock.new
    
    @subject = ListCreator.new(2, :user, { name: "Walter" }, FactoriesStore.new, Sequencer.new)

    2.times do
      object_creator.expect(:create_object, Object, [Symbol, Hash, FactoriesStore, Sequencer])
    end
  end
  
  def test_create_list
    subject.stub(:object_creator, object_creator) do
      subject.create_list
    end
    
    assert object_creator.verify
  end
  
  def test_resulting_list_is_an_array
    subject.stub(:object_creator, object_creator) do
      subject.create_list
      
      assert Array, subject.list.class
    end
  end
end