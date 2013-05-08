require "sidekiq"
require "active_support"
require "active_support/core_ext"

require "sidekiq/throttler/version"
require "sidekiq/throttler/rate_limit"
require "sidekiq/throttler/statsd"

module Sidekiq
  ##
  # Sidekiq StatsD is a middleware to increment your worker executions counter (success and failures).
  # It makes possible to follow your workers executions in fancy graphics using Graphite.
  #
  # @param [Hash] options the parameters to initialize the StatsD client.
  # @option opts [String] :env ("production") env.prefix.worker_name.success|failure.
  # @option opts [String] :prefix ("worker")
  # @option opts [String] :host ("localhost")
  # @option opts [String] :port ("8125")
  class Throttler
    def initialize options={}
      @options = options
    end

    ##
    # Increments the metrics.
    #
    # @param [Sidekiq::Worker] worker
    #   The worker the job belongs to.
    #
    # @param [Hash] msg
    #   The job message.
    #
    # @param [String] queue
    #   The current queue.
    def call worker, msg, queue
      stastd = Sidekiq::Throttler::Statsd.new @options
      yield
      stastd.increment [worker.class.name, "success"].join(".")
    rescue => e
      stastd.increment [worker.class.name, "failure"].join(".")
      raise e
    end

  end # Throttler
end # Sidekiq
