# encoding: utf-8

require 'statsd'

module Sidekiq::Statsd
  ##
  # Sidekiq StatsD is a middleware to track worker execution metrics through statsd.
  #
  class ServerMiddleware
    ##
    # Initializes the middleware with options.
    #
    # @param [Hash] options The options to initialize the StatsD client.
    # @option options [Statsd] :statsd Existing statsd client.
    # @option options [String] :env ("production") The env to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :prefix ("worker") The prefix to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :host ("localhost") The StatsD host.
    # @option options [String] :port ("8125") The StatsD port.
    def initialize options={}
      @options = { env:    "production",
                   prefix: "worker",
                   host:   "localhost",
                   port:   8125 }.merge options
      @statsd = options[:statsd] || ::Statsd.new(@options[:host], @options[:port])
      @sidekiq_stats = Sidekiq::Stats.new
    end

    ##
    # Pushes the metrics in a batch.
    #
    # @param worker [Sidekiq::Worker] The worker the job belongs to.
    # @param msg [Hash] The job message.
    # @param queue [String] The current queue.
    def call worker, msg, queue
      @statsd.batch do |b|
        begin
          b.time prefix(worker.class.name, 'processing_time') do
            yield
          end
          b.increment prefix(worker.class.name, 'success')
        rescue => e
          b.increment prefix(worker.class.name, 'failure')
          raise e
        ensure
          # Queue sizes
          b.gauge prefix('enqueued'), @sidekiq_stats.enqueued
          b.gauge prefix('retry_set_size'), @sidekiq_stats.retry_size

          # All-time counts
          b.gauge prefix('processed'), @sidekiq_stats.processed
          b.gauge prefix('failed'), @sidekiq_stats.failed

          # Queue metrics
          queue_name = msg['queue']
          sidekiq_queue = Sidekiq::Queue.new(queue_name)
          b.gauge prefix('queues', queue_name, 'enqueued'), sidekiq_queue.size
          b.gauge prefix('queues', queue_name, 'latency'), sidekiq_queue.latency
        end
      end
    end

    private

    ##
    # Converts args passed to it into a metric name with prefix.
    #
    # @param [String] args One or more strings to be converted to a metric name.
    def prefix(*args)
      [@options[:env], @options[:prefix], *args].compact.join('.')
    end
  end # ServerMiddleware
end # Sidekiq
