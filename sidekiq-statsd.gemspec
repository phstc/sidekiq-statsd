# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sidekiq/statsd/version"

Gem::Specification.new do |gem|
  gem.name          = "sidekiq-statsd"
  gem.version       = Sidekiq::Statsd::VERSION
  gem.authors       = ["Pablo Cantero"]
  gem.email         = ["pablo@pablocantero.com"]
  gem.description   = %q{Sidekiq StatsD is a Sidekiq server middleware to send Sidekiq worker metrics through statsd.}
  gem.summary       = %q{Sidekiq StatsD is a Sidekiq server middleware to send Sidekiq worker metrics through statsd.}
  gem.homepage      = "https://github.com/phstc/sidekiq-statsd"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_dependency "sidekiq", ">= 2.5"
  gem.add_dependency "statsd-ruby", ">= 1.1.0"
end
