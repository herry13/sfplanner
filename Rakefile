def sfplanner
	File.dirname(__FILE__) + '/bin/sfplanner'
end

def testfiles
	dir = File.dirname(__FILE__) + '/test'
	File.read("#{dir}/files").split("\n").map { |x| "#{dir}/#{x}" }
end

task :default => :test

namespace :test do
	testfiles.each do |file|
		sh("#{sfplanner} #{file}")
	end
end
