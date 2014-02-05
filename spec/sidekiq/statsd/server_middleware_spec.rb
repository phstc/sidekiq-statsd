require "spec_helper"

describe Sidekiq::Statsd::ServerMiddleware do
  subject(:statsd) { described_class.new }

  let(:worker) { double "Dummy worker" }
  let(:msg)    { {} }
  let(:queue)  { nil }
  let(:client) { double "Statsd client" }

  before do
    client.stub gauge: true
    Sidekiq::Statsd::Client.stub new: client
  end

  describe "#call" do
    it "increments success" do
      client.
        should_receive(:increment).
        with "#{worker.class.name}.success"

      statsd.call(worker, msg, queue) {}
    end

    it "increments failure" do
      client.
        stub(:increment).
        with "#{worker.class.name}.failure"

      b = ->{ raise "error" }

      expect{ statsd.call(worker, msg, queue, &b) }.to raise_error
    end
  end
end

