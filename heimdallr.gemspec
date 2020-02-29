lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'heimdallr/version'

Gem::Specification.new do |spec|
  spec.name        = 'heimdallr'
  spec.version     = Heimdallr::VERSION
  spec.authors     = ['Nate Strandberg']
  spec.email       = ['nater540@gmail.com']
  spec.homepage    = 'https://github.com/nater540/heimdallr'
  spec.summary     = 'JWT Middleware for Ruby on Rails'
  spec.description = 'JWT Authorization engine'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 2.5'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable', '~> 0.8.2'
  spec.add_dependency 'jwt'
  spec.add_dependency 'graphql', '>= 1.9.3', '< 2'
  spec.add_dependency 'activesupport', '>= 5.2'
  spec.add_dependency 'argon2', '~> 2.0', '>= 2.0.2'

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'vault', '~> 0.12.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
