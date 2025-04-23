# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class BreachedAccount < Endpoint
      ALLOWED_PARAMS = %i[domain include_unverified truncate_response].freeze

      class << self
        def call(account:, **kwargs)
          truncate = kwargs[:truncate_response] != false
          params = parse_optional_params(kwargs, ALLOWED_PARAMS)

          data = Client.get(uri(account, params))

          Models::BreachCollection.new(data, truncated: truncate)
        rescue NotFound
          Models::BreachCollection.new({})
        end

        private

        def uri(account, params)
          encoded_account = URI.encode_www_form_component(account)
          uri = URI("#{endpoint_url}breachedaccount/#{encoded_account}")
          uri.query = URI.encode_www_form(params) unless params.empty?
          uri
        end
      end
    end
  end
end
