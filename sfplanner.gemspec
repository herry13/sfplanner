Gem::Specification.new do |s|
	s.name			= 'sfplanner'
	s.version		= File.read(File.join(File.dirname(__FILE__), 'VERSION')).sub(/\n/, '')
	s.date			= '2013-08-13'
	s.summary		= 'SFPlanner'
	s.description	= 'A Ruby gem that provides a Ruby API and a script to the SFP planner. This planner can automatically generate a plan that solves a planning problem written in SFP language.'
	s.authors		= ['Herry']
	s.email			= 'herry13@gmail.com'

	s.executables << 'sfplanner'
	s.files			= `git ls-files`.split("\n")

	s.require_paths = ['lib']
	s.license       = 'BSD'

	s.homepage		= 'https://github.com/herry13/sfplanner'
	s.rubyforge_project = 'sfplanner'

	s.add_dependency 'sfp', '~> 0.3.11'
end	
