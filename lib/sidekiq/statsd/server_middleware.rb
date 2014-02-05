# encoding: utf-8

module Sidekiq::Statsd
  ##
  # Sidekiq StatsD is a middleware to increment your worker executions counter (success and failures).
  #
  class ServerMiddleware
    ##
    # Initializes the middleware with options.
    #
    # @param [Hash] options The options to initialize the StatsD client.
    # @option options [String] :env ("production") The env to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :prefix ("worker") The prefix to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :host ("localhost") The StatsD host.
    # @option options [String] :port ("8125") The StatsD port.
    def initialize options={}
      @statsd = Sidekiq::Statsd::Client.new options
      @sidekiq_stats = Sidekiq::Stats.new
    end

    ##
    # Increments the metrics.
    #
    # @param worker [Sidekiq::Worker] The worker the job belongs to.
    # @param msg [Hash] The job message.
    # @param queue [String] The current queue.
    def call worker, msg, queue
      yield
      @statsd.increment prefix(worker.class.name, "success")
    rescue => e
      @statsd.increment prefix(worker.class.name, "failure")
      raise e
    ensure
      @statsd.gauge 'enqueued', @sidekiq_stats.enqueued
      @statsd.gauge 'processed', @sidekiq_stats.processed
      @statsd.gauge 'failed', @sidekiq_stats.failed

      queue_name = msg['queue']
      sidekiq_queue = Sidekiq::Queue.new(queue_name)
      @statsd.gauge prefix(queue_name, 'enqueued'), sidekiq_queue.size
      @statsd.gauge prefix(queue_name, 'latency'), sidekiq_queue.latency
    end

    private

    def prefix(*args)
      args.compact.join('.')
    end

  end # ServerMiddleware
end # Sidekiq

