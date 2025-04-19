# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class SubscribedDomains < Endpoint
      class << self
        def call
          Client.get(uri)
        end

        private

        def uri
          URI("#{endpoint_url}subscribeddomains")
        end
      end
    end
  end
end
