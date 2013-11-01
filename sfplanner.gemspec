Gem::Specification.new do |s|
	s.name          = 'sfplanner'
	s.version       = File.read(File.dirname(__FILE__) + '/VERSION').strip
	s.date          = File.atime(File.dirname(__FILE__) + '/VERSION').strftime("%Y-%m-%d").to_s
	s.summary       = 'SFPlanner'
	s.description   = 'A Ruby gem that provides a Ruby API and a script to the SFP planner. This planner can automatically generate a plan that solves a planning problem written in SFP language.'
	s.authors       = ['Herry']
	s.email	        = 'herry13@gmail.com'

	s.executables   << 'sfplanner'
	s.executables   << 'sfw2graph'
	s.files         = `git ls-files`.split("\n")

	s.require_paths = ['lib']
	s.license       = 'BSD'

	s.homepage                   = 'https://github.com/herry13/sfplanner'
	s.rubyforge_project          = 'sfplanner'

	s.add_dependency             'sfp', '~> 0.4'

	s.add_development_dependency 'rake'
end	
