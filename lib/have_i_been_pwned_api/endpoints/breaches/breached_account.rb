# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class BreachedAccount < Endpoint
      ALLOWED_PARAMS = %i[domain include_unverified truncate_response].freeze

      class << self
        def call(account:, **kwargs)
          params = {}
          kwargs.map do |key, value|
            next unless ALLOWED_PARAMS.include?(key)
            key = HaveIBeenPwnedApi::Utils::Strings.camelize_param(key.to_s)
            params[key] = value unless value.nil?
          end

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
