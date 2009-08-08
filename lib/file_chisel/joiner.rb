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
        @outputfile = "outputfile.mp4"
        @info = YAML.load_file("#{@dirpath}/.infofile.yml")
    end

    def join
        @output = File.new(@outputfile, "w")
        (@info[:count]).times do |i|
        serial = "%08d" % (i)
        f = File.new("#{@dirpath}/#{serial}", "r")
        @output.print(f.read)
        f.close
        end
        @output.close
    end
  end
end

