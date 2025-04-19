# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class BreachedDomain < Endpoint
      class << self
        def call(domain:)
          Client.get(uri(domain))
        end

        private

        def uri(domain)
          URI("#{endpoint_url}breacheddomain/#{domain}")
        end
      end
    end
  end
end
