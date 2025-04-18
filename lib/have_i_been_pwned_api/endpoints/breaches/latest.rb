# frozen_string_literal: true

require_relative "../endpoint"

module HaveIBeenPwnedApi
  module Breaches
    class Latest < Endpoint
      class << self
        def call
          Client.get(uri)
        end

        private

        def path
          "latestbreach"
        end

        def uri
          uri = URI("#{endpoint_url}#{path}")
          #uri.query = URI.encode_www_form(params) unless params.empty?
          uri
        end
      end
    end
  end
end
