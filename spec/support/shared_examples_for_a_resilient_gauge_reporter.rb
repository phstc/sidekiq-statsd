require 'active_support/testing/time_helpers'

shared_examples "a resilient gauge reporter" do
  include ActiveSupport::Testing::TimeHelpers

  let(:sidekiq_stats) { double(enqueued: 1, processed: 2, failed: 3, retry_size: 4) }
  let!(:sidekiq_workers) { [["pid", "tid", { "queue" => "my_queue", "run_at" => Time.now.to_i }]] }
  let(:queue_stats)   { double(size: 3, latency: 4.2) }

  before do
    allow(Sidekiq::Stats).to receive(:new) { sidekiq_stats }
    allow(Sidekiq::Queue).to receive(:new).with('mailer') { queue_stats }
    allow(Sidekiq::Workers).to receive(:new) { sidekiq_workers }
  end

  it "gauges enqueued jobs" do
    expect(client)
      .to receive(:gauge)
      .with("production.worker.enqueued", 1)
      .once

    middleware.call(worker, msg, queue, &job)
  end

  it "gauges processed jobs" do
    expect(client)
      .to receive(:gauge)
      .with("production.worker.processed", 2)
      .once

    middleware.call(worker, msg, queue, &job)
  end

  it "gauges failed jobs" do
    expect(client)
      .to receive(:gauge)
      .with("production.worker.failed", 3)
      .once

    middleware.call(worker, msg, queue, &job)
  end

  it "gauges retry set size" do
    expect(client)
      .to receive(:gauge)
      .with("production.worker.retry_set_size", 4)
      .once

    middleware.call(worker, msg, queue, &job)
  end

  it "gauges queue depth" do
    expect(client)
      .to receive(:gauge)
      .with("production.worker.queues.mailer.enqueued", 3)
      .once

    middleware.call(worker, msg, queue, &job)
  end

  it "gauges queue latency" do
    expect(client)
      .to receive(:gauge)
      .with("production.worker.queues.mailer.latency", 4.2)
      .once

    middleware.call(worker, msg, queue, &job)
  end

  it "gauges precessing jobs" do
    expect(client)
      .to receive(:gauge)
      .with("production.worker.queues.my_queue.processing", 1)
      .once

    middleware.call(worker, msg, queue, &job)
  end

  it "gauges job runtime" do
    travel_to 5.minutes.from_now

    expect(client)
      .to receive(:gauge)
      .with("production.worker.queues.my_queue.runtime", 300)
      .once

    middleware.call(worker, msg, queue, &job)
  end
end
