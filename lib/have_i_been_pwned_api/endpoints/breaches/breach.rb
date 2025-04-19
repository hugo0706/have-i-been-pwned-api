# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class Breach < Endpoint
      class << self
        def call(name:)
          Client.get(uri(name))
        end

        private

        def uri(name)
          URI("#{endpoint_url}breach/#{name}")
        end
      end
    end
  end
end
