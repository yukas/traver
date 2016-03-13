module Traver
  class FactoriesLoader
    attr_reader :base_dir, :folder_name
    attr_reader :factories_loaded
    
    FILE_NAME = "factories.rb"
    
    def initialize(base_dir, folder_name = "test")
      @base_dir = base_dir
      @folder_name = folder_name
      
      @factories_loaded = false
    end
    
    def load_factories
      unless factories_loaded
        factories_file_path = File.join(base_dir, folder_name, FILE_NAME)
    
        require factories_file_path
        
        @factories_loaded = true
      end
    end
  end
  
  class NilFactoriesLoader
    def load_factories
    end
  end
end