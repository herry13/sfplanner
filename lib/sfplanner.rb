# external dependencies
require 'rubygems'
require 'json'
require 'sfp'

# internal dependencies
libdir = File.dirname(__FILE__) + '/sfplanner'
Dir.entries(libdir).each do |item|
	require "#{libdir}/#{item}" if File.extname(item) == '.rb'
end
