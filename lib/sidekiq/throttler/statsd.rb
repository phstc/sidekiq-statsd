# encoding: utf-8

module Sidekiq
  class Throttler
    class Statsd
      ##
      # Initializes StatsD client.
      #
      # @param [Hash] options the parameters to initialize the StatsD client.
      # @option opts [String] :env ("production") env.prefix.worker_name.success|failure.
      # @option opts [String] :prefix ("worker")
      # @option opts [String] :host ("localhost")
      # @option opts [String] :port ("8125")
      def initialize options={}
        @options = { "prefix" => "worker",
                     "env"    => "production",
                     "host"   => "localhost",
                     "port"   => 8125 }.merge options

        @statsd_client = ::Statsd.new @options["host"], @options["port"]
      end

      def increment key
        @statsd_client.increment [@options["env"], @options["prefix"], key].join(".")
      end
    end
  end
end

