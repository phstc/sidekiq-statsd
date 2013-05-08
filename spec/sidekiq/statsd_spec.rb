require "spec_helper"

describe Sidekiq::Statsd do
  subject(:statsd) { described_class.new }

  let(:worker) { double "Dummy worker" }
  let(:msg)    { nil }
  let(:queue)  { nil }

  describe "#call" do
    it "increments success" do
      Sidekiq::Statsd::Client.any_instance.
        should_receive(:increment).
        with "#{worker.class.name}.success"

      statsd.call(worker, msg, queue) {}
    end

    it "increments failure" do
      Sidekiq::Statsd::Client.any_instance.
        should_receive(:increment).
        with "#{worker.class.name}.failure"

      b = ->{ raise "error" }

      expect{ statsd.call(worker, msg, queue, &b) }.to raise_error
    end
  end
end

