# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class Breaches < Endpoint
      ALLOWED_PARAMS = %i[domain is_spam_list].freeze

      class << self
        def call(**kwargs)
          params = {}
          kwargs.map do |key, value|
            next unless ALLOWED_PARAMS.include?(key)
            key = HaveIBeenPwnedApi::Utils::Strings.camelize_param(key.to_s)
            params[key] = value unless value.nil?
          end

          Client.get(uri(params))
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
