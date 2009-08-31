$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'active_support'

module FileChisel
  VERSION = '0.0.2'
  DEFAULT_PART_DIR = "#{ENV['HOME']}/shuebox/parts/" 
end

Dir["#{File.dirname(__FILE__)}/file_chisel/*\.rb"].each do |file|
  require File.expand_path(file)
end  

