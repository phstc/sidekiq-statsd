require "rspec-redis_helper"

RSpec.configure do |spec|
  spec.include RSpec::RedisHelper, redis: true

  # clean the Redis database around each run
  # @see https://www.relishapp.com/rspec/rspec-core/docs/hooks/around-hooks
  spec.around(:each, redis: true) do |example|
    with_clean_redis do
      example.run
    end
  end
end
