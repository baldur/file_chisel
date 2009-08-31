require 'rubygems'
require 'ruby-debug'
require 'curb'
require 'digest/sha1'
require 'fileutils'

module FileChisel
  class Splitter
    attr_reader :part_directory
  
    def self.split(filepath) 
      @splitter = new(filepath)
      @splitter.split
    end

    def initialize(filepath)
      @file              = File.new(filepath, "r")
      @original_filename = File.basename(filepath)
      @block_size        = 32768 # (1024*32)  @file.stat.blksize
      @file_size         = @file.stat.size
      @start_position    = 0
      @counter           = 0
      @part_filename     = ""
      @part_map         = {}
      @part_directory   = FileChisel::DEFAULT_PART_DIR
    end

    def split
      while @start_position < @file_size 
        content = IO.read(@file.path, @block_size, @start_position)
        @part_filename = Digest::SHA1.new.update(content).hexdigest
        @part_map[@counter] = @part_filename
        create_fraction_file!(content)
        @start_position += @block_size
        @counter += 1
      end
      create_info_file!
    end

    def part_directory=(path)
      @part_directory = FileChisel.valid_directory_path_for(path)
    end

    private

      def make_part_directory!
        FileUtils.mkdir_p(@part_directory + hashed_directory_for_part)
      end

      def path_to_part_file
        @part_directory + hashed_directory_for_part + @part_filename
      end

      def hashed_directory_for_part
        FileChisel.hash_directory_for(@part_filename)
      end

      def info_for_file
        { :count => @counter,
          :block_size => @block_size,
          :last_file_size => @file_size % @block_size,
          :parts_map => @part_map }
        # TODO fix part(s) typo ... 
        # carfully since there are external apps that use this
      end

      def create_info_file!
        file = File.new("#{@file.path}.manifest.yml", "w")
        file.print(info_for_file.to_yaml)
        file.close
      end

      def create_fraction_file!(content)
        make_part_directory! 
        file = File.new(path_to_part_file, "w")
        file.print(content)
        file.close
      end
  end
end

