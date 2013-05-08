require "spec_helper"

describe Sidekiq::Throttler do
  subject(:throttler) { described_class.new }

  let(:worker) { double "Dummy worker" }
  let(:msg)    { nil }
  let(:queue)  { nil }

  describe "#call" do
    it "increments success" do
      Sidekiq::Throttler::Statsd.any_instance.
        should_receive(:increment).
        with "#{worker.class.name}.success"

      throttler.call(worker, msg, queue) {}
    end

    it "increments failure" do
      Sidekiq::Throttler::Statsd.any_instance.
        should_receive(:increment).
        with "#{worker.class.name}.failure"

      b = ->{ raise "error" }

      expect{ throttler.call worker, msg, queue, &b }.to raise_error
    end
  end
end
