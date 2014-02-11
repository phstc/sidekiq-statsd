# Sidekiq::Statsd

[![Build Status](https://secure.travis-ci.org/phstc/sidekiq-statsd.png)](http://travis-ci.org/phstc/sidekiq-statsd)
[![Dependency Status](https://gemnasium.com/phstc/sidekiq-statsd.png)](https://gemnasium.com/phstc/sidekiq-statsd)

Sidekiq StatsD is a [Sidekiq server middleware](https://github.com/mperham/sidekiq/wiki/Middleware) to send [Sidekiq worker metrics](https://github.com/mperham/sidekiq/wiki/API#wiki-stats) through [statsd](https://github.com/reinh/statsd).

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
    chain.add Sidekiq::Statsd::ServerMiddleware, env: "production", prefix: "worker", host: "localhost", port: 8125
  end
end
```

### Sidekiq::Statsd::ServerMiddleware options

```ruby
# @param [Hash] options The options to initialize the StatsD client.
# @option options [Statsd] :statsd Existing statsd client to use.
# @option options [String] :env ("production") The env to segment the metric key (e.g. env.prefix.worker_name.success|failure).
# @option options [String] :prefix ("worker") The prefix to segment the metric key (e.g. env.prefix.worker_name.success|failure).
# @option options [String] :host ("localhost") The StatsD host.
# @option options [String] :port ("8125") The StatsD port.
```

If you have a [statsd instance](https://github.com/github/statsd-ruby) you can pass it through the `:statsd` option. If not you can pass the `:host` and `:port` to connect to statsd.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT Licensed. See LICENSE.txt for details.
