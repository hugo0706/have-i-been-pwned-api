# frozen_string_literal: true

require_relative "have_i_been_pwned_api/version"
require_relative "have_i_been_pwned_api/configuration"

module HaveIBeenPwnedApi
  autoload :Client, "have_i_been_pwned_api/client"
  autoload :Error, "have_i_been_pwned_api/error"
  autoload :Breaches, "have_i_been_pwned_api/endpoints/breaches"

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config) if block_given?
  end
end
