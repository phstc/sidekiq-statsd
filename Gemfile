source 'https://rubygems.org'
gemspec

gem 'sidekiq', ENV['SIDEKIQ_VERSION'] if ENV['SIDEKIQ_VERSION']

group :development do
  gem  'rake'
  gem  'pry'
  gem  'yard'
  gem  'redcarpet', platforms: [:ruby]

  gem  'rspec', '~> 2.14.1'
  gem  'rspec-redis_helper'
  gem  'timecop'
  gem  'simplecov'

  gem  'guard'
  gem  'guard-bundler'
  gem  'guard-rspec'
  gem  'guard-yard'
  gem  'rb-fsevent'
  gem  'rb-inotify'
  gem  'growl'
end
