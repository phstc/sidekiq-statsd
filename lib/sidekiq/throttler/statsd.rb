# encoding: utf-8

module Sidekiq
  class Throttler
    class Statsd
      ##
      # Initializes StatsD client with options.
      #
      # @param [Hash] options The options to initialize the StatsD client.
      # @option options [String] :env ("production")
      # @option options [String] :prefix ("worker")
      # @option options [String] :host ("localhost")
      # @option options [String] :port ("8125")
      def initialize options={}
        @options = { "env"    => "production",
                     "prefix" => "worker",
                     "host"   => "localhost",
                     "port"   => 8125 }.merge options

        @statsd_client = ::Statsd.new @options["host"], @options["port"]
      end

      ##
      # Increments the counter.
      #
      # StatsD key format: env.prefix.worker_name.success|failure.
      #
      # @param key [String] The key to be incremented.
      def increment key
        @statsd_client.increment [@options["env"], @options["prefix"], key].join(".")
      end
    end
  end
end

