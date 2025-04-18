# frozen_string_literal: true

require_relative "have_i_been_pwned_api/version"
require_relative "have_i_been_pwned_api/configuration"

module HaveIBeenPwnedApi
  autoload :Client, "have_i_been_pwned_api/client"
  autoload :Error, "have_i_been_pwned_api/error"

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end
