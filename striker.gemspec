# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'striker/version'

Gem::Specification.new do |spec|
  spec.name          = "striker"
  spec.version       = Striker::VERSION
  spec.authors       = ["Swaroop SM"]
  spec.email         = ["swaroop.striker@gmail.com"]
  spec.description   = %q{Simple & Fast Static Site Generator}
  spec.summary       = %q{A super simple static site generator with quick creation of pages.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "commander", "~> 4.1.5"
  spec.add_runtime_dependency "safe_yaml", "~> 0.9.7"
  spec.add_runtime_dependency "liquid", "~> 2.5.3"
  spec.add_runtime_dependency "redcarpet", "~> 3.0.0"
  spec.add_runtime_dependency "webrick", "~> 1.3.1"
  spec.add_runtime_dependency "stringex", "~> 2.1.0"
  spec.add_runtime_dependency "mime-types", "~> 1.25"
  spec.add_runtime_dependency "rmagick", "~> 2.13.2"
end
