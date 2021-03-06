require './lib/jruby-warck/version.rb'
Gem::Specification.new do |s|
  s.name        = "jruby-warck"
  s.version     = JrubyWarck::VERSION.version 
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nuno Correia"]
  s.license     = "MIT"
  s.email       = ["nuno-g-correia@ext.ptinovacao.pt"]
  s.homepage    = "http://github.com/ptinovacao/rubygem-jruby-warck"
  s.summary     = "Kinda like warbler, except our way"
  s.description = "Kinda like warbler, except WAR-only and contained in a single Rakefile."
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'jruby-rack'
  s.add_runtime_dependency 'rubyzip', '~> 1.1', '>= 1.1.7'
 
  s.files        = `git ls-files`.split("\n") 
  s.executables  << 'warck'
  s.require_path = 'lib'
end
