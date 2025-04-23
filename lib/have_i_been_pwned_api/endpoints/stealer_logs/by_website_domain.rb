# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module StealerLogs
    class ByWebsiteDomain < Endpoint
      class << self
        def call(domain:)
          Client.get(uri(domain))
        end

        private

        def uri(domain)
          encoded_domain = URI.encode_www_form_component(domain)
          URI("#{endpoint_url}stealerlogsbywebsitedomain/#{encoded_domain}")
        end
      end
    end
  end
end
