# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'runby_pace/version'

Gem::Specification.new do |spec|
  spec.name          = 'runby_pace'
  spec.version       = RunbyPace::VERSION
  spec.authors       = ['Ty Walls']
  spec.email         = ['tygerbytes@users.noreply.github.com']

  spec.summary       = %q{Runby Pace is the core logic which simplifies the calculation target paces used by track and distance runners.}
  spec.homepage      = 'https://github.com/tygerbytes/runby-pace'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
