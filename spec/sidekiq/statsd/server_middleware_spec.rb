require "spec_helper"

describe Sidekiq::Statsd::ServerMiddleware do
  subject(:middleware) { described_class.new(statsd: client) }

  let(:worker) { double "Dummy worker" }
  let(:msg)    { { 'queue' => 'mailer' } }
  let(:queue)  { nil }
  let(:client) { double('StatsD').as_null_object }

  let(:worker_name) { worker.class.name.gsub("::", ".") }

  let(:clean_job)  { ->{} }
  let(:broken_job) { ->{ raise 'error' } }

  before do
    allow(client).to receive(:batch).and_yield(client)
  end

  it "raises error if no statsd supplied" do
    expect { described_class.new }.to raise_error("A StatsD client must be provided")
  end

  context "with customised options" do
    describe "#new" do
      it "uses the custom metric name prefix options" do
        expect(client)
          .to receive(:time)
          .with("development.application.sidekiq.#{worker_name}.processing_time")
          .once
          .and_yield

        described_class
          .new(statsd: client, env: 'development', prefix: 'application.sidekiq')
          .call(worker, msg, queue, &clean_job)
      end
    end
  end

  context 'without global sidekiq stats' do
    it "doesn't initialize a Sidekiq::Stats instance" do
      # Sidekiq::Stats.new makes redis calls
      expect(Sidekiq::Stats).not_to receive(:new)
      described_class.new(statsd: client, sidekiq_stats: false)
    end

    it "doesn't initialize a Sidekiq::Workers instance" do
      # Sidekiq::Workers.new makes redis calls
      expect(Sidekiq::Workers).not_to receive(:new)
      described_class.new(statsd: client, sidekiq_stats: false)
    end

    it "doesn't gauge sidekiq stats" do
      expect(client).not_to receive(:enqueued)
      expect(client).not_to receive(:retry_size)
      expect(client).not_to receive(:processed)
      expect(client).not_to receive(:failed)

      described_class
        .new(statsd: client, sidekiq_stats: false)
        .call(worker, msg, queue, &clean_job)
    end
  end

  context "with successful execution" do
    let(:job) { clean_job }

    describe "#call" do
      it "increments success counter" do
        expect(client)
          .to receive(:increment)
          .with("production.worker.#{worker_name}.success")
          .once

        middleware.call(worker, msg, queue, &job)
      end

      it "times the process execution" do
        expect(client)
          .to receive(:time)
          .with("production.worker.#{worker_name}.processing_time")
          .once
          .and_yield

        middleware.call(worker, msg, queue, &job)
      end
    end

    it_behaves_like "a resilient gauge reporter"
  end

  context "with failed execution" do
    let(:job) { broken_job }

    describe "#call" do
      before do
        allow(client)
          .to receive(:time)
          .with("production.worker.#{worker_name}.processing_time")
          .and_yield
      end

      it "increments failure counter" do
        expect(client)
          .to receive(:increment)
          .with("production.worker.#{worker_name}.failure")
          .once

        expect{ middleware.call(worker, msg, queue, &job) }.to raise_error('error')
      end
    end

    it_behaves_like "a resilient gauge reporter"
  end
end
