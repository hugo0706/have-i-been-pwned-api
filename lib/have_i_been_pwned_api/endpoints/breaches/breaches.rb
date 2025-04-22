# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class Breaches < Endpoint
      ALLOWED_PARAMS = %i[domain is_spam_list].freeze

      class << self
        def call(**kwargs)
          params = parse_optional_params(kwargs, ALLOWED_PARAMS)

          data = Client.get(uri(params))
          Models::BreachCollection.new(data, truncated: false)
        end

        private

        def uri(params)
          uri = URI("#{endpoint_url}breaches")
          uri.query = URI.encode_www_form(params) unless params.empty?
          uri
        end
      end
    end
  end
end
