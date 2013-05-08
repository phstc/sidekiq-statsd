# -*- encoding: utf-8 -*-
require "helper"

describe Redis, redis: true, redis_configuration: true do

  it "should be redis" do
    redis.should be_kind_of(Redis)
  end

end
