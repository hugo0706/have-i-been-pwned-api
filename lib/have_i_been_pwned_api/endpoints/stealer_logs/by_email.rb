# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module StealerLogs
    class ByEmail < Endpoint
      class << self
        def call(email:)
          Client.get(uri(email))
        end

        private

        def uri(email)
          URI("#{endpoint_url}stealerlogsbyemail/#{email}")
        end
      end
    end
  end
end
