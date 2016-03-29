class Sequencer
  attr_reader :sequence_store
  
  def initialize
    @sequence_store = {}
  end
  
  def value_has_sequence?(value)
    !!(value =~ /\$\{n\}/)
  end
  
  def interpolate_sequence(name, value)
    value.sub("${n}", next_sequence_value_for(name).to_s)
  end
  
  private
  
  def next_sequence_value_for(name)
    sequence_store[name] ||= 0 
    sequence_store[name] += 1
    
    sequence_store[name]
  end
end