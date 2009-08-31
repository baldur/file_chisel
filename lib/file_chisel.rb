$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'active_support'

module FileChisel
  VERSION = '0.0.2'
  DEFAULT_PART_DIR = "#{ENV['HOME']}/shuebox/parts/" 

  def self.hash_directory_for(value)
    value.unpack('aaaaa').push('').join('/')
  end

  def self.valid_directory_path_for(value)
    # slapping / on path if it is not provided
    value =~ /.*\/$/ ? value : "#{value}/"
  end
end

Dir["#{File.dirname(__FILE__)}/file_chisel/*\.rb"].each do |file|
  require File.expand_path(file)
end  

