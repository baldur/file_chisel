require 'rubygems'
require 'ruby-debug'
require 'curb'
require 'digest/sha1'

module FileChisel
  class Splitter
  
    def self.split(filepath) 
      @splitter = new(filepath)
      @splitter.split
    end

    def initialize(filepath)
      @file = File.new(filepath, "r")

      @dirname = File.basename(filepath)[0..-5]
      Dir.mkdir(@dirname) unless directory_exsists?(@dirname)

      @block_size     = 32768 # (1024*32)  @file.stat.blksize
      @file_size      = @file.stat.size
      @start_position = 0
      @counter        = 0
    end

    def split
      parts_map = {}
      while @start_position < @file_size 
      content = IO.read(@file.path, @block_size, @start_position)

      filename = Digest::SHA1.new.update(content).hexdigest

      parts_map[@counter] = filename

      create_fraction_file!(@dirname + "/" + filename, content)
      @start_position += @block_size
      @counter += 1
      end
      info = { :count => @counter,
              :block_size => @block_size,
              :last_file_size => @file_size % @block_size,
              :parts_map => parts_map }
      create_info_file!(info)
    end

    private

      def create_info_file!(info)
        file = File.new("#{@dirname}/.infofile.yml", "w")
        file.print(info.to_yaml)
        file.close
      end

      def directory_exsists?(name)
        File.exists?(name) 
      end
      
      def create_fraction_file!(serial, content)
        file = File.new(serial, "w")
        file.print(content)
        file.close
      end

  end
end

