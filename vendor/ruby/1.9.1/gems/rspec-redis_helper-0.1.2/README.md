# RSpec::RedisHelper

This module will help you write specs which use Redis.
It sets up two Redis connections.
It also clears out Redis between examples.
It uses db 1 on localhost by default.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-redis_helper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-redis_helper

## Usage

Configure RSpec in your support or helper file like so:

    RSpec.configure do |spec|
      spec.include RSpec::RedisHelper, redis: true

      # clean the Redis database around each run
      # @see https://www.relishapp.com/rspec/rspec-core/docs/hooks/around-hooks
      spec.around( :each, redis: true ) do |example|
        with_clean_redis do
          example.run
        end
      end
    end

You will also need to configure your app to use one of these redis connections,
or to be initialized from RSpec::RedisHelper::CONFIG.

Then mark your Redis-using specs with redis: true, like so:

    describe MyApp, redis: true do
      it "has access to redis" do
        redis.should_not be_nil
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
