require 'rubygems'
require 'ruby-debug'
require 'curb'
require 'yaml'

module FileChisel
  class Joiner
    def self.join(dirpath)
      @joiner = new(dirpath)
      @joiner.join
    end

    def initialize(dirpath)
      @dirpath = dirpath
      @outputfile = "#{@dirpath}.reassembled.mp4"
      @info = YAML.load_file("#{@dirpath}.manifest.yml")
    end

    def join
      @output = File.new(@outputfile, "w")
      (@info[:count]).times do |i|
        hashed_dir = "#{@info[:parts_map][i].unpack('aaaaa').push('').join('/')}" 
        f = File.new("#{FileChisel::PARTS_DIR}#{hashed_dir}/#{@info[:parts_map][i]}", "r")
        @output.print(f.read)
        f.close
      end
      @output.close
    end
  end
end

