# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'job_up_app/version'

Gem::Specification.new do |spec|
  spec.name          = "JobUpApp"
  spec.version       = JobUpApp::VERSION
  spec.authors       = ["Shaun Ashby"]
  spec.email         = ["Shaun.Ashby@gmail.com"]
  spec.description   = %q{Provide a simple web application to access JobUp search results.}
  spec.summary       = %q{A web application to access JobUp search results.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack"
end
