# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in have_i_been_pwned_api.gemspec
gemspec

gem "rake", "~> 13.0"

group :development, :test do
  gem "debug"
  gem "dotenv"
  gem "rubocop", "~> 1.21"
  gem "solargraph"
end

group :test do
  gem "simplecov", require: false
  gem 'simplecov-cobertura'
  gem "rspec", "~> 3.0"
  gem "webmock"
end
