require "test_helper"

class SequencerTest < TraverTest
  attr_reader :subject
  
  def setup
    @subject = Sequencer.new
  end
  
  def test_value_has_sequence
    assert_equal true, subject.value_has_sequence?("Hello ${n}")
  end
  
  def test_value_has_no_sequence
    assert_equal false, subject.value_has_sequence?("Hello")
  end
  
  def test_increments_value
    assert_equal "qwe1@qwe.qwe", subject.interpolate_sequence(:email, "qwe${n}@qwe.qwe")
    assert_equal "qwe2@qwe.qwe", subject.interpolate_sequence(:email, "qwe${n}@qwe.qwe")
  end
  
  def test_each_term_has_separate_sequence
    assert_equal "qwe1@qwe.qwe", subject.interpolate_sequence(:email, "qwe${n}@qwe.qwe")
    assert_equal "qwe2@qwe.qwe", subject.interpolate_sequence(:email, "qwe${n}@qwe.qwe")
    
    assert_equal "Hello 1", subject.interpolate_sequence(:title, "Hello ${n}")
    assert_equal "Hello 2", subject.interpolate_sequence(:title, "Hello ${n}")
  end
end