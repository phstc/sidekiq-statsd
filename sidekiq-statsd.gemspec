# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sidekiq/statsd/version"

Gem::Specification.new do |gem|
  gem.name          = "sidekiq-statsd"
  gem.version       = Sidekiq::Statsd::VERSION
  gem.authors       = ["Pablo Cantero"]
  gem.email         = ["pablo@pablocantero.com"]
  gem.description   = %q{Sidekiq StatsD is a middleware to increment your worker executions counter (success and failures).}
  gem.summary       = %q{Sidekiq StatsD is a middleware to increment your worker executions counter (success and failures).}
  gem.homepage      = "https://github.com/phstc/sidekiq-statsd"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_dependency "sidekiq", ">= 2.5", "< 3.0"
  gem.add_dependency "statsd-ruby", ">= 1.1.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "redcarpet"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-redis_helper"
  gem.add_development_dependency "timecop"
  gem.add_development_dependency "simplecov"

  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "guard-yard"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "rb-inotify"
  gem.add_development_dependency "growl"
end
