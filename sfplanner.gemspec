Gem::Specification.new do |s|
	s.name			= 'sfplanner'
	s.version		= '0.0.1'
	s.date			= '2013-07-03'
	s.summary		= 'SFPlanner'
	s.description	= 'A Ruby gem that provides a Ruby API and a script to the SFP planner. This planner can automatically generate a plan that solves a planning problem written in SFP language.'
	s.authors		= ['Herry']
	s.email			= 'herry13@gmail.com'

	s.executables << 'sfplanner'
	s.files			= `git ls-files`.split("\n")

	s.require_paths = ['lib']

	s.homepage		= 'https://github.com/herry13/sfp-planner'
	s.rubyforge_project = 'sfp-planner'

	s.add_dependency 'sfp', '~> 0.3.0'
end	
