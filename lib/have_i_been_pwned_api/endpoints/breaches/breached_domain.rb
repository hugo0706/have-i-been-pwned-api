# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class BreachedDomain < Endpoint
      class << self
        def call(domain:)
          data = Client.get(uri(domain))

          Models::BreachedDomain.new(data)
        rescue NotFound
          Models::BreachedDomain.new({})
        end

        private

        def uri(domain)
          encoded_domain = URI.encode_www_form_component(domain)
          URI("#{endpoint_url}breacheddomain/#{encoded_domain}")
        end
      end
    end
  end
end
