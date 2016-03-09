class ArClassDefiner
  attr_reader :defined_classes
  
  def initialize
    @defined_classes = []
    
    establish_connection
  end
  
  def define_class(class_name, attributes = {}, &block)
    defined_class = Object.const_set(class_name.to_s.capitalize, Class.new(ActiveRecord::Base))
    defined_classes << defined_class
    
    create_table(defined_class.table_name) do |table|
      attributes.each do |attr_name, attr_type|
        table.column attr_name, attr_type
      end
    end
    
    defined_class.class_eval(&block) if block_given?
  end
  
  def undefine_all_classes
    defined_classes.each do |klass|
      undefine_class(klass)
    end
  end
  
  def undefine_class(klass)
    drop_table(klass.table_name)
    remove_constant(klass.to_s)
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
    connection.create_table(table_name, &block)
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

  class ClassDefinerTest < Minitest::Test
    attr_reader :class_definer
    
    def setup
      @class_definer = ArClassDefiner.new
    end
    
    def teardown
      class_definer.undefine_all_classes
    end
    
    def test_defines_class
      class_definer.define_class(:blog)
    
      assert_equal ActiveRecord::Base, Blog.superclass
    end
    
    def test_defines_class_with_attributes
      class_definer.define_class(:blog, title: :string)
      
      assert_equal ["id", "title"], Blog.new.attributes.keys
    end
    
    def test_defines_class_with_assocociation
      class_definer.define_class(:user)
      
      class_definer.define_class(:blog, user_id: :integer) do
        belongs_to :user
      end
      
      assert_equal :user, Blog.reflect_on_association(:user).name
    end
  end
end