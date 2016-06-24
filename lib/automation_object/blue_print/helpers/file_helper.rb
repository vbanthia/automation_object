module AutomationObject::BluePrint
  #Collect files in directory recursively and return Array
  module FileHelper
    # @param path [String] specified directory path for getting files underneath
    # @returns [Array] list of file paths that exist recursively underneath a directory
    def collect_files(path)
      unless File.exists?(path)
        raise "Expecting path to exist, got #{path}"
      end

      if File.directory?(path)
        @file_array = Array.new
        self.recursive_collection(path)
      else
        @file_array = [path]
      end

      @file_array
    end

    protected

    # Use for recursive collection of files
    # @param path [String] specified directory path for getting files underneath
    def recursive_collection(path)
      Dir.foreach(path) do |item|
        next if item == '.' or item == '..'

        file_path = File.join(path, "#{item}")
        if File.directory?(file_path)
          self.recursive_collection(file_path)
        else
          @file_array.push(file_path)
        end
      end
    end
  end
end