require "test_helper"

class GraphCreatorTest < TraverTest
  def subject
    @subject ||= GraphCreator.new(:blog,  { title: "Hello" }, FactoriesStore.new, Sequencer.new)
  end
  
  def test_create_graph
    define_class("Blog", :title)
    
    subject.create_graph
    
    assert_instance_of Blog, subject.graph.blog
  end
end