# encoding: utf-8

require "statsd"

module Sidekiq::Statsd
  class Client
    ##
    # Initializes StatsD client with options.
    #
    # @param [Hash] options The options to initialize the StatsD client.
    # @option options [String] :env ("production") The env to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :prefix ("worker") The prefix to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :host ("localhost") The StatsD host.
    # @option options [String] :port ("8125") The StatsD port.
    def initialize options={}
      @options = { env:    "production",
                   prefix: "worker",
                   host:   "localhost",
                   port:   8125 }.merge options

      @statsd_client = ::Statsd.new @options[:host], @options[:port]
    end

    ##
    # Increments the counter.
    #
    # StatsD key format: env.prefix.worker_name.success|failure.
    #
    # @param key [String] The key to be incremented.
    def increment key
      @statsd_client.increment [@options[:env], @options[:prefix], key].join(".")
    end

    def gauge key, value
      @statsd_client.gauge [@options[:env], @options[:prefix], key].join("."), value
    end
  end
end

