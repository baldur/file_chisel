#! /usr/bin/env ruby
# this is just to get a sense of what this gem does
require 'rubygems'
require '../lib/file_chisel'

case ARGV.first
  when "split"
    splitter = FileChisel::Splitter.new("example.mp4")
    splitter.part_directory = './tmp/'
    splitter.split
  when "join"
    joiner = FileChisel::Joiner.new("new_assembled_example.mp4", YAML.load_file("example.mp4.manifest.yml")[:parts_map])
    joiner.part_directory = './tmp/'
    joiner.join
  else
    msg = <<-EOL
      Plese specify argument
      ruby runner.rb split
      or
      ruby runner.rb join
    EOL
    puts msg
end

