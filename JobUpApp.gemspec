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
  spec.summary       = "JobUpApp-#{spec.version}"
  spec.homepage      = ""
  spec.license       = "GPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "json"
  spec.add_dependency "sinatra"
  spec.add_dependency "redis"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "json"
  spec.add_development_dependency "thin"
  spec.add_development_dependency "redis"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec"
end
