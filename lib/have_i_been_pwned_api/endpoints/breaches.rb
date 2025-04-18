# frozen_string_literal: true

require_relative "breaches/latest"

module HaveIBeenPwnedApi
  module Breaches
    def self.latest
      puts Latest.call
    end
  end
end
