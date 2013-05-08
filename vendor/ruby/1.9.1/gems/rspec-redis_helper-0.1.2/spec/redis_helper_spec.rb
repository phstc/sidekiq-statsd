# -*- encoding: utf-8 -*-
require "helper"

describe RSpec::RedisHelper do

  include RSpec::RedisHelper

  it "should be redis" do
    redis.should be_kind_of(Redis)
  end

  it "should clean redis before and after" do
    redis.set "it", "bar"
    with_clean_redis do
      redis.get("it").should eq(nil)
      redis.set "it", "bar"
    end
    redis.get("it").should eq(nil)
  end

  it "has a watch helper" do
    with_clean_redis do
      with_watch( redis, "it" ) do
        redis.multi do |r|
          r.set "it", "my value"
        end
      end.should eq(["OK"])
    end
  end

  it "can use the redis2 connection to intentionally fail transactions" do
    with_clean_redis do
      with_watch( redis, "it" ) do
        redis2.set "it", "interference"
        redis.multi do |r|
          r.set "it", "my value"
        end
      end.should be_nil
    end
  end

end
