# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cookie_cutter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andy Alm"]
  gem.email         = ["private"]
  gem.description   = %q{Provides a way to define the structure, lifetime, and other properties of a cookie all in one place.}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/andyalm/cookie_cutter"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cookie_cutter"
  gem.require_paths = ["lib"]
  gem.version       = CookieCutter::VERSION

  gem.add_dependency 'actionpack'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
