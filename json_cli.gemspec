# -*- mode: ruby; coding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "json_cli"
  spec.version       = JsonCli::VERSION
  spec.authors       = ["Masaaki Kikuchi"]
  spec.email         = ["masa21kik@gmail.com"]
  spec.description   = %q{JSON command line tools}
  spec.summary       = %q{JSON command line tools}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json"
  spec.add_dependency "thor"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "flay"
  spec.add_development_dependency "flog"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "rubocop", "~> 0.49"
end
