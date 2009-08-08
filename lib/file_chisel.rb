$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'active_support'

module FileChisel
  VERSION = '0.0.1'
end

Dir["#{File.dirname(__FILE__)}/file_chisel/*\.rb"].each do |file|
  #inferred_classname = File.basename(file).gsub(/\.rb$/, '').camelcase
  require File.expand_path(file)
  #autoload "FileChisel::#{inferred_classname}", File.expand_path(file)
end  

