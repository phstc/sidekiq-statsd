# encoding: utf-8

module Sidekiq::Statsd
  ##
  # Sidekiq StatsD is a middleware to track worker execution metrics through statsd.
  #
  class ServerMiddleware
    ##
    # Initializes the middleware with options.
    #
    # @param [Hash] options The options to initialize the StatsD client.
    # @option options [Statsd] :statsd Existing StatsD client.
    # @option options [String] :env ("production") The env to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :prefix ("worker") The prefix to segment the metric key (e.g. env.prefix.worker_name.success|failure).
    # @option options [String] :sidekiq_stats ("true") Send Sidekiq global stats e.g. total enqueued, processed and failed.
    def initialize(options = {})
      @options = { env: 'production', prefix: 'worker', sidekiq_stats:  true }.merge options

      @statsd = options[:statsd] || raise("A StatsD client must be provided")
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
          # colon causes invalid metric names
          worker_name = worker.class.name.gsub('::', '.')

          b.time prefix(worker_name, 'processing_time') do
            yield
          end

          b.increment prefix(worker_name, 'success')
        rescue => e
          b.increment prefix(worker_name, 'failure')
          raise e
        ensure
          report_global_stats(b) if @options[:sidekiq_stats]
          report_queue_stats(b, msg['queue'])
        end
      end
    end

    private

    def report_global_stats(statsd)
      sidekiq_stats = Sidekiq::Stats.new

      # Queue sizes
      statsd.gauge prefix('enqueued'), sidekiq_stats.enqueued
      statsd.gauge prefix('retry_set_size'), sidekiq_stats.retry_size

      # All-time counts
      statsd.gauge prefix('processed'), sidekiq_stats.processed
      statsd.gauge prefix('failed'), sidekiq_stats.failed
    end

    def report_queue_stats(statsd, queue_name)
      sidekiq_queue = Sidekiq::Queue.new(queue_name)
      statsd.gauge prefix('queues', queue_name, 'enqueued'), sidekiq_queue.size
      statsd.gauge prefix('queues', queue_name, 'latency'), sidekiq_queue.latency
    end

    ##
    # Converts args passed to it into a metric name with prefix.
    #
    # @param [String] args One or more strings to be converted to a metric name.
    def prefix(*args)
      [@options[:env], @options[:prefix], *args].compact.join('.')
    end
  end # ServerMiddleware
end # Sidekiq

