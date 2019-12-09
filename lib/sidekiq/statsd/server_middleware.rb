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
      @options = { env:            'production',
                   prefix:         'worker',
                   host:           'localhost',
                   port:           8125,
                   sidekiq_stats:  true }.merge options

      @statsd = options[:statsd] || raise("A StatsD client must be provided")
      @sidekiq_stats = Sidekiq::Stats.new if @options[:sidekiq_stats]
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
          if @options[:sidekiq_stats]
            # Queue sizes
            b.gauge prefix('enqueued'), @sidekiq_stats.enqueued
            if @sidekiq_stats.respond_to?(:retry_size)
              # 2.6.0 doesn't have `retry_size`
              b.gauge prefix('retry_set_size'), @sidekiq_stats.retry_size
            end

            # All-time counts
            b.gauge prefix('processed'),  @sidekiq_stats.processed
            b.gauge prefix('failed'),     @sidekiq_stats.failed
          end

          # Queue metrics
          queue_name = msg['queue']
          sidekiq_queue = Sidekiq::Queue.new(queue_name)
          b.gauge prefix('queues', queue_name, 'enqueued'), sidekiq_queue.size
          if sidekiq_queue.respond_to?(:latency)
            b.gauge prefix('queues', queue_name, 'latency'), sidekiq_queue.latency
          end
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
