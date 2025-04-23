# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module StealerLogs
    class ByEmailDomain < Endpoint
      class << self
        def call(domain:)
          Client.get(uri(domain))
        rescue NotFound
          {}
        end

        private

        def uri(domain)
          encoded_domain = URI.encode_www_form_component(domain)
          URI("#{endpoint_url}stealerlogsbyemaildomain/#{encoded_domain}")
        end
      end
    end
  end
end
