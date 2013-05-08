# Sidekiq::Statsd

[![Build Status](https://secure.travis-ci.org/phstc/sidekiq-statsd.png)](http://travis-ci.org/phstc/sidekiq-statsd)
[![Dependency Status](https://gemnasium.com/phstc/sidekiq-statsd.png)](https://gemnasium.com/phstc/sidekiq-statsd)

Sidekiq StatsD is a middleware to increment your worker executions counter (success and failures).

## Compatibility

Sidekiq::Statsd is tested against MRI 1.9.3.

## Installation

Add this line to your application's Gemfile:

    gem "sidekiq-statsd"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-statsd

## Configuration

In a Rails initializer or wherever you've configured Sidekiq, add
Sidekiq::Statsd to your server middleware:

```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Statsd, env: "production", prefix: "worker", host: "localhost", port: 8125
  end
end
```

## Usage

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT Licensed. See LICENSE.txt for details.