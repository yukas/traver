module Traver
  class FactoriesLoader
    attr_reader :base_dir, :folder_name
    attr_reader :factories_loaded
    
    FOLDER_NAMES = ["test", "spec"]
    FILE_NAMES   = ["factories.rb", "traver_factories.rb"]
    
    def initialize(base_dir)
      @base_dir = base_dir
      
      @factories_loaded = false
    end
    
    def load_factories
      unless factories_loaded
        FOLDER_NAMES.each do |folder_name|
          FILE_NAMES.each do |file_name|
            load_file(folder_name, file_name)
          end
        end
        
        @factories_loaded = true
      end
    end
    
    private
    
    def load_file(folder_name, file_name)
      file_path = File.join(base_dir, folder_name, file_name)
      
      if file_class.exist?(file_path)
        kernel_module.require file_path
      end
    end
    
    def kernel_module
      Kernel
    end
    
    def file_class
      File
    end
  end
end