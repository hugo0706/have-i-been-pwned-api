# frozen_string_literal: true

require "net/http"
require "uri"

module HaveIBeenPwnedApi
  class Client
    class << self
      def get(path, params = {})
        uri = URI("#{config.base_url}#{path}")
        uri.query = URI.encode_www_form(params) unless params.empty?

        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        request["hibp-api-key"] = config.api_key
        request["user-agent"] = "test"
        http.request(request).body
      end

      private

      def config
        HaveIBeenPwnedApi.configuration
      end
    end
  end
end
