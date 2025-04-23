# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class DataClasses < Endpoint
      class << self
        def call
          Client.get(uri)
        rescue NotFound
          []
        end

        private

        def uri
          URI("#{endpoint_url}dataclasses")
        end
      end
    end
  end
end
