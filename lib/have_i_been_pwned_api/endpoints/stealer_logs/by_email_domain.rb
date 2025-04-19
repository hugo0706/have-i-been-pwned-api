# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module StealerLogs
    class ByEmailDomain < Endpoint
      class << self
        def call(domain:)
          Client.get(uri(domain))
        end

        private

        def uri(domain)
          URI("#{endpoint_url}stealerlogsbyemaildomain/#{domain}")
        end
      end
    end
  end
end
