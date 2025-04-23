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
          encoded_email = URI.encode_www_form_component(email)
          URI("#{endpoint_url}stealerlogsbyemail/#{encoded_email}")
        end
      end
    end
  end
end
