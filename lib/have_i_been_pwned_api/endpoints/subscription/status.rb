# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Subscription
    class Status < Endpoint
      class << self
        def call
          Client.get(uri)
        end

        private

        def uri
          URI("#{endpoint_url}subscription/status")
        end
      end
    end
  end
end
