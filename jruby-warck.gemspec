require 'lib/jruby-warck/version.rb'
Gem::Specification.new do |s|
  s.name        = "jruby-warck"
  s.version     = JrubyWarck::VERSION.version 
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nuno Correia"]
  s.email       = ["nuno-g-correia@ext.ptinovacao.pt"]
  s.homepage    = "http://github.com/ptinovacao/rubygem-jruby-warck"
  s.summary     = "Kinda like warbler, except our way"
  s.description = "Kinda like warbler, except WAR-only and contained in a single Rakefile."

  %w{rack rubyzip jruby-jars jruby-rack}.each { |dep| s.add_runtime_dependency dep }
  
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables  << 'warck'
  s.require_path = 'lib'
end
