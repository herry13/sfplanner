# external dependencies
require 'rubygems'
require 'json'
require 'sfp'

# internal dependencies
libdir = File.dirname(__FILE__) + '/sfplanner'
['planner.rb', 'sas.rb', 'graph.rb'].each do |item|
	require "#{libdir}/#{item}" if File.extname(item) == '.rb'
end
