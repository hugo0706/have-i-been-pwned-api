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
          URI("#{endpoint_url}stealerlogsbywebsitedomain/#{domain}")
        end
      end
    end
  end
end
