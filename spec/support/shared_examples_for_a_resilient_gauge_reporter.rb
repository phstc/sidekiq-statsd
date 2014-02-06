shared_examples "a resilient gauge reporter" do
  let(:sidekiq_stats) { double(enqueued: 1, processed: 2, failed: 3, retry_size: 4) }
  let(:queue_stats)   { double(size: 3, latency: 4.2) }

  before do
    Sidekiq::Stats.stub(:new).and_return(sidekiq_stats)
    Sidekiq::Queue.stub(:new).with('mailer').and_return(queue_stats)
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
end
