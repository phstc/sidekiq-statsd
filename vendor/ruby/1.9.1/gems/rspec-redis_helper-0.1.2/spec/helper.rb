# -*- encoding: utf-8 -*-
require "bundler/setup"         # set up gem paths
require "redis"
require "rspec-redis_helper"    # load this gem

RSpec.configure do |spec|
  spec.include RSpec::RedisHelper, redis: true

  # clean the Redis database around each example
  spec.around( :each, redis: true ) do |example|
    with_clean_redis do
      example.run
    end
  end
end
