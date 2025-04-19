# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class BreachedAccount < Endpoint
      ALLOWED_PARAMS = %i[domain include_unverified truncate_response].freeze

      class << self
        def call(account:, **kwargs)
          params = parse_optional_params(kwargs, ALLOWED_PARAMS)

          Client.get(uri(account, params))
        end

        private

        def uri(account, params)
          uri = URI("#{endpoint_url}breachedaccount/#{account}")
          uri.query = URI.encode_www_form(params) unless params.empty?
          uri
        end
      end
    end
  end
end
