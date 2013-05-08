require "spec_helper"
require "statsd"

describe Sidekiq::Statsd::Client do
  let(:worker_name)   { "ImageWorker" }
  let(:statsd_client) { double "Statsd Client" }

  before { ::Statsd.stub new: statsd_client }

  context "user defined options" do
    let(:options) do
      { "prefix" => "super",
        "env"    => "man",
        "host"   => "lobster",
        "port"   => 6666 }
    end

    subject(:statsd) { described_class.new options }

    describe "#initialize" do
      it "initializes Statsd client" do
        ::Statsd.should_receive(:new).with options["host"], options["port"]
        statsd
      end
    end

    describe "#increment" do
      it "increments counter" do
        statsd_client.should_receive(:increment).with [options["env"], options["prefix"], worker_name].join(".")
        statsd.increment worker_name
      end
    end
  end

  context "default options" do
    subject(:statsd) { described_class.new }

    describe "#initialize" do
      it "initializes StatsD client" do
        ::Statsd.should_receive(:new).with "localhost", 8125
        statsd
      end
    end

    describe "#increment" do
      it "increments counter" do
        statsd_client.should_receive(:increment).with "production.worker.#{worker_name}"
        statsd.increment worker_name
      end
    end
  end
end

