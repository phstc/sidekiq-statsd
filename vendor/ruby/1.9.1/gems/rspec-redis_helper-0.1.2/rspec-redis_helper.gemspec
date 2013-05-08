# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspec-redis_helper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mark Lanett"]
  gem.email         = ["mark.lanett@gmail.com"]
  gem.description   = %q{Helper for RSpec tests which use Redis}
  gem.summary       = %q{Helper for RSpec tests which use Redis}
  gem.homepage      = "http://github.com/mlanett/rspec-redis_helper"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rspec-redis_helper"
  gem.require_paths = ["lib"]
  gem.version       = RSpec::RedisHelper::VERSION

  gem.add_dependency "redis"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
