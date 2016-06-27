# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myra/version'

Gem::Specification.new do |spec|
  spec.name          = 'myra'
  spec.version       = Myra::VERSION
  spec.authors       = ['Florian Kraft']
  spec.email         = ['florian.kraft@kloeckner.com']

  spec.summary       = 'Gem for interacting with the MyraCloud API'
  spec.description   = 'This gem allows for interacting with the MyraCloud API to manipulate website and their DNS entries, etc.'
  spec.homepage      = 'https://github.com/kloeckner-i/myra'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.41'

  spec.add_dependency 'faraday', '~> 0.8.11'
end
