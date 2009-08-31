require 'rubygems'
require 'ruby-debug'
require 'curb'
require 'yaml'

module FileChisel
  class Joiner

    attr_reader :part_directory

    def self.join(filename, info)
      @joiner = new(filename, info)
      @joiner.join
    end

    def initialize(assembled_filename, info)
      @part_directory = FileChisel::DEFAULT_PART_DIR
      @outputfile = assembled_filename 
      @info = info
    end

    def join
      write_assembled_file {
        @info.sort.each do |pair|
            @part_filename = pair[1]
            @output.print(read_part_file)
        end
      }
    end

    def part_directory=(path)
      @part_directory = FileChisel.valid_directory_path_for(path)
    end

    private

      def write_assembled_file
        @output = File.new(@outputfile, "w")
        yield
        @output.close
      end

      def read_part_file
        f = File.new(path_to_part_file, "r")
        content = f.read
        f.close
        return content
      end

      def path_to_part_file
        "#{@part_directory}#{hashed_directory_for_part}/#{@part_filename}"
      end

      def hashed_directory_for_part
        FileChisel.hash_directory_for(@part_filename)
      end
  end
end

