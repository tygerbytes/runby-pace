# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'runby_pace/version'

Gem::Specification.new do |spec|
  spec.name          = 'runby_pace'
  spec.version       = Runby::VERSION
  spec.authors       = ['Ty Walls']
  spec.email         = ['tygerbytes@users.noreply.github.com']

  spec.summary       = 'Runby Pace is the core logic which simplifies the calculation of target paces used by track and distance runners.'
  spec.homepage      = 'https://github.com/tygerbytes/runby-pace'
  spec.license       = 'MIT'

  spec.metadata      = { 'commit-hash' => `git log -n 1 --pretty=format:"%H"` }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files         += `git ls-files -z --other */*.g.rb`.split("\x0")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.2'

  spec.add_development_dependency 'bundler', '~> 2.2.10'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
