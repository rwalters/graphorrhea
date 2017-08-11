# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphorrhea/version'

Gem::Specification.new do |spec|
  spec.name          = "graphorrhea"
  spec.version       = Graphorrhea::VERSION
  spec.authors       = ["Ray Walters"]
  spec.email         = ["ray.walters@gmail.com"]

  spec.summary       = %q{Generate random words and phrases}
  spec.description   = %q{Generate random words and phrases as an exploration project}
  spec.homepage      = "https://github.com/rwalters/graphorrhea"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
