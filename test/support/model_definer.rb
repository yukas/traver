require "active_record"

class ModelDefiner
  attr_reader :defined_models
  
  def initialize
    @defined_models = []
    
    establish_connection
  end
  
  def define_model(model_name, attributes = {}, &block)
    defined_model = Object.const_set(model_name.to_s.camelize, Class.new(ActiveRecord::Base))
    defined_models << defined_model
    
    create_table(defined_model.table_name) do |table|
      attributes.each do |attr_name, attr_type|
        table.column attr_name, attr_type
      end
    end
    
    defined_model.class_eval(&block) if block_given?
  end
  
  def undefine_all_models
    defined_models.each do |model|
      undefine_model(model)
    end
    
    @defined_models = []
  end
  
  def undefine_model(model)
    drop_table(model.table_name)
    remove_constant(model.to_s)
  end
  
  private
  attr_reader :connection
  
  def establish_connection
    ActiveRecord::Base.establish_connection(
      adapter:  "sqlite3",
      database: File.join(File.dirname(__FILE__), "test.db")
    )
    
    @connection = ActiveRecord::Base.connection
  end
  
  def create_table(table_name, &block)
    begin
      connection.create_table(table_name, &block)
    rescue Exception => e
      drop_table(table_name)
      
      raise e
    end
  end
  
  def drop_table(table_name)
    connection.execute("DROP TABLE IF EXISTS #{table_name}")
  end
  
  def remove_constant(const_name)
    Object.send(:remove_const, const_name)
  end
end
  
if __FILE__ == $0
  require "bundler/setup"
  require "active_record"
  require "minitest/autorun"

  class ModelDefinerTest < Minitest::Test
    attr_reader :subject
    
    def setup
      @subject = ModelDefiner.new
    end
    
    def teardown
      subject.undefine_all_models
    end
    
    def test_define_model
      subject.define_model(:blog)

      assert defined?(Blog)
      assert_equal ActiveRecord::Base, Blog.superclass
    end
    
    def test_define_model_with_attributes
      subject.define_model(:blog, title: :string)
      
      assert_equal ["id", "title"], Blog.new.attributes.keys
    end
    
    def test_define_model_with_assocociation
      subject.define_model(:user)
      
      subject.define_model(:blog, user_id: :integer) do
        belongs_to :user
      end
      
      assert_equal :user, Blog.reflect_on_association(:user).name
    end
    
    def test_undefine_all_models
      subject.define_model(:user)
      subject.define_model(:blog)
      
      subject.undefine_all_models

      refute defined?(User)
      refute defined?(Blog)
    end
  end
end